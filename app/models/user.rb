class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # アソシエーション
  has_many :clients, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  # fullnameを必須項目として検証
  validates :fullname, presence: true

  def active_subscription
    subscriptions.active_subscriptions.first
  end

  def has_active_subscription?
    active_subscription.present?
  end

  def stripe_customer
    return nil unless active_subscription&.stripe_customer_id

    @stripe_customer ||= Stripe::Customer.retrieve(active_subscription.stripe_customer_id)
  rescue Stripe::StripeError
    nil
  end

  def has_any_unjoinable_subscription?
    # 有効・未完了・トライアル中、または「キャンセル済み かつ end_date > 現在」
    subscriptions.where(
      "(status IN (?) OR (status = ? AND end_date > ?))",
      [Subscription.statuses[:active], Subscription.statuses[:incomplete], Subscription.statuses[:trialing]],
      Subscription.statuses[:canceled],
      Time.current
    ).exists?
  end
end
