# == Schema Information
#
# Table name: subscriptions
#
#  id                     :bigint           not null, primary key
#  amount                 :integer
#  end_date               :datetime
#  plan_name              :string
#  start_date             :datetime
#  status                 :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  plan_id                :integer
#  stripe_customer_id     :string
#  stripe_subscription_id :string
#  user_id                :bigint           not null
#
# Indexes
#
#  index_subscriptions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Subscription < ApplicationRecord
  belongs_to :user

  enum :status, {
    incomplete: 0,
    incomplete_expired: 1,
    trialing: 2,
    active: 3,
    past_due: 4,
    canceled: 5,
    unpaid: 6
  }

  validates :plan_id, presence: true, on: :create
  validates :stripe_customer_id, presence: true
  validates :stripe_subscription_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :no_duplicate_subscription, on: :create
  validate :valid_plan_id

  scope :active_subscriptions, -> { where(status: statuses[:active]) }

  # ActiveHashのPlanモデルとの関連付け
  def plan
    Plan.find(plan_id) if plan_id
  end

  def plan=(plan)
    self.plan_id = plan&.id
    self.plan_name = plan&.name
    self.amount = plan&.price
  end

  def monthly_amount_in_yen
    # planが設定されている場合はplanの価格を使用、そうでなければamountを使用（後方互換性）
    plan&.price_in_yen || amount
  end

  # plan_nameのgetter（後方互換性のため）
  def plan_name
    plan&.name || super
  end

  def cancel!
    return false unless stripe_subscription_id

    begin
      stripe_subscription = Stripe::Subscription.retrieve(stripe_subscription_id)
      # Stripeのcurrent_period_endはitems.data[0].current_period_end
      period_end = stripe_subscription['items']['data'][0]['current_period_end'] rescue nil
      if period_end
        effective_end_date = Time.at(period_end).in_time_zone - 1.day
        update!(status: 'canceled', end_date: effective_end_date)
      else
        update!(status: 'canceled')
      end

      stripe_subscription.cancel_at_period_end = true
      stripe_subscription.save

      true
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe subscription cancellation failed: #{e.message}"
      false
    end
  end

  def resume!
    return false unless stripe_subscription_id

    begin
      stripe_subscription = Stripe::Subscription.retrieve(stripe_subscription_id)
      stripe_subscription.cancel_at_period_end = false
      stripe_subscription.save

      update!(status: 'active', end_date: nil)
      true
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe subscription resume failed: #{e.message}"
      false
    end
  end

  def status_jp
    case status.to_sym
    when :active
      '有効'
    when :canceled
      'キャンセル'
    when :past_due
      '支払い遅延'
    when :trialing
      'トライアル中'
    when :incomplete
      '未完了'
    when :incomplete_expired
      '未完了（期限切れ）'
    when :unpaid
      '未払い'
    else
      status
    end
  end

  def no_duplicate_subscription
    # 有効・未完了・トライアル中、または「キャンセル済みでend_dateが未来」のサブスクがあれば新規作成不可
    if user && user.subscriptions.where(
      "(status IN (?) OR (status = ? AND end_date > ?))",
      [Subscription.statuses[:active], Subscription.statuses[:incomplete], Subscription.statuses[:trialing]],
      Subscription.statuses[:canceled],
      Time.current
    ).exists?
      errors.add(:base, 'すでに有効・未完了、または解約予定のサブスクリプションが存在します')
    end
  end

  def valid_plan_id
    # plan_idが存在する場合、そのplan_idに対応するPlanレコードが存在するか検証
    if plan_id.present? && Plan.find_by(id: plan_id).nil?
      errors.add(:plan_id, '選択されたプランは無効です')
    end
  end
end
