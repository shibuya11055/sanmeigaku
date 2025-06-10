class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscription, only: [:cancel, :resume]

  def index
    @subscriptions = current_user.subscriptions.order(created_at: :desc)
    @active_subscription = current_user.active_subscription
  end

  def new
    if current_user.has_any_unjoinable_subscription?
      redirect_to subscriptions_path, alert: 'すでに有効・未完了、または解約予定のサブスクリプションが存在します。新規加入はできません。'
      return
    end
    @subscription = current_user.subscriptions.build
  end

  def create
    if current_user.subscriptions.where(status: %i[active incomplete trialing]).exists?
      redirect_to subscriptions_path, alert: 'すでに有効または未完了のサブスクリプションがあります。'
      return
    end

    begin
      # Stripeで顧客を作成または取得
      customer = create_or_get_stripe_customer

      # Stripeでサブスクリプションを作成
      stripe_subscription = create_stripe_subscription(customer)

      # データベースにサブスクリプションを保存
      @subscription = current_user.subscriptions.build(
        plan_name: "ベーシックプラン",
        amount: 100,
        stripe_customer_id: customer.id,
        stripe_subscription_id: stripe_subscription.id,
        status: stripe_subscription.status,
        start_date: Time.current
      )

      if @subscription.save
        redirect_to subscriptions_path, notice: 'サブスクリプションが正常に作成されました。'
      else
        flash.now[:alert] = 'サブスクリプションの作成に失敗しました。'
        render :new
      end

    rescue Stripe::StripeError => e
      flash.now[:alert] = "決済処理でエラーが発生しました: #{e.message}"
      render :new
    end
  end

  def cancel
    if @subscription.cancel!
      redirect_to subscriptions_path, notice: 'サブスクリプションがキャンセルされました。'
    else
      redirect_to @subscription, alert: 'サブスクリプションのキャンセルに失敗しました。'
    end
  end

  def resume
    if @subscription.resume!
      redirect_to subscriptions_path, notice: 'サブスクリプションが再開されました。'
    else
      redirect_to @subscription, alert: 'サブスクリプションの再開に失敗しました。'
    end
  end

  private

  def set_subscription
    @subscription = current_user.subscriptions.find(params[:id])
  end

  def create_or_get_stripe_customer
    # 既存の顧客がいるかチェック
    existing_subscription = current_user.subscriptions.where.not(stripe_customer_id: nil).first

    if existing_subscription&.stripe_customer_id
      Stripe::Customer.retrieve(existing_subscription.stripe_customer_id)
    else
      Stripe::Customer.create(
        email: current_user.email,
        name: current_user.fullname,
        metadata: {
          user_id: current_user.id
        }
      )
    end
  end

  def create_stripe_subscription(customer)
    # 既存の100円・月額・JPYプランを検索
    price = Stripe::Price.list(
      lookup_keys: nil,
      limit: 100
    ).data.find do |p|
      p.unit_amount == 100 &&
      p.currency == 'jpy' &&
      p.recurring &&
      p.recurring.interval == 'month' &&
      p.product && Stripe::Product.retrieve(p.product).name == 'ベーシックプラン'
    end

    unless price
      price = Stripe::Price.create(
        unit_amount: 100, # 100円
        currency: 'jpy',
        recurring: { interval: 'month' },
        product_data: { name: 'ベーシックプラン' }
      )
    end

    # サブスクリプションを作成
    Stripe::Subscription.create(
      customer: customer.id,
      items: [{ price: price.id }],
      payment_behavior: 'default_incomplete',
      payment_settings: { save_default_payment_method: 'on_subscription' },
      expand: ['latest_invoice.payment_intent']
    )
  end
end
