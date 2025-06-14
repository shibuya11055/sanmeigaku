require 'rqrcode'

class TwoFactorController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_two_factor_not_enabled, only: [:setup, :enable]
  before_action :ensure_two_factor_enabled, only: [:disable]

  def setup
    @user = current_user

    # 既にシークレットが存在しない場合のみ新しく生成
    unless @user.otp_secret.present?
      @user.enable_two_factor!
    end

    qr_code = RQRCode::QRCode.new(@user.qr_code_uri)
    @qr_code_svg = qr_code.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 4,
      standalone: true
    )
    @backup_codes = @user.backup_codes_array
  end

  def enable
    Rails.logger.info "OTP Code received: #{params[:otp_code]}"
    Rails.logger.info "User OTP Secret: #{current_user.otp_secret}"

    verification_result = current_user.verify_otp(params[:otp_code])
    Rails.logger.info "OTP Verification result: #{verification_result}"

    if verification_result
      current_user.update!(otp_enabled: true)
      redirect_to user_path, notice: '2要素認証が有効になりました。'
    else
      flash.now[:alert] = '認証コードが正しくありません。'
      @user = current_user

      qr_code = RQRCode::QRCode.new(@user.qr_code_uri)
      @qr_code_svg = qr_code.as_svg(
        offset: 0,
        color: '000',
        shape_rendering: 'crispEdges',
        module_size: 4,
        standalone: true
      )
      @backup_codes = @user.backup_codes_array
      render :setup
    end
  end

  def disable
    if current_user.valid_password?(params[:password])
      current_user.disable_two_factor!
      redirect_to user_path, notice: '2要素認証が無効になりました。'
    else
      redirect_to user_path, alert: 'パスワードが正しくありません。'
    end
  end

  private

  def ensure_two_factor_not_enabled
    if current_user.otp_enabled?
      redirect_to user_path, notice: '2要素認証は既に有効になっています。'
    end
  end

  def ensure_two_factor_enabled
    unless current_user.otp_enabled?
      redirect_to user_path, alert: '2要素認証が有効になっていません。'
    end
  end
end
