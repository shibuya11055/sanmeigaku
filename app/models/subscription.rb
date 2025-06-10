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

  validates :stripe_customer_id, presence: true
  validates :stripe_subscription_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :no_duplicate_subscription, on: :create

  scope :active_subscriptions, -> { where(status: statuses[:active]) }

  def monthly_amount_in_yen
    amount
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
end
