require 'rotp'
require 'securerandom'
require 'cgi'

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

  # 2要素認証関連のメソッド
  def enable_two_factor!
    self.otp_secret = ROTP::Base32.random
    self.backup_codes = generate_backup_codes.to_json
    save!
  end

  def disable_two_factor!
    self.otp_enabled = false
    self.otp_secret = nil
    self.backup_codes = nil
    save!
  end

  def two_factor_enabled?
    otp_enabled? && otp_secret.present?
  end

  def verify_otp(token)
    Rails.logger.info "verify_otp called with token: #{token}"
    Rails.logger.info "otp_secret present: #{otp_secret.present?}"

    return false unless otp_secret.present?

    totp = ROTP::TOTP.new(otp_secret)
    result = totp.verify(token, drift_behind: 30, drift_ahead: 30)
    Rails.logger.info "ROTP verify result: #{result}"

    result
  end

  def verify_backup_code(code)
    return false unless backup_codes.present?

    codes = JSON.parse(backup_codes)
    if codes.include?(code)
      codes.delete(code)
      self.backup_codes = codes.to_json
      save!
      return true
    end
    false
  end

  def qr_code_uri
    return nil unless otp_secret.present?

    # ROTPライブラリのバグを回避するため、手動でURI生成
    issuer = "Unilo"
    account_name = email

    "otpauth://totp/#{CGI.escape("#{issuer}:#{account_name}")}?secret=#{otp_secret}&issuer=#{CGI.escape(issuer)}"
  end

  def backup_codes_array
    return [] unless backup_codes.present?
    JSON.parse(backup_codes)
  end

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

  private

  def generate_backup_codes
    10.times.map { SecureRandom.hex(4).upcase }
  end
end
