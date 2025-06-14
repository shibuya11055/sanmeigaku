class TwoFactorAuthenticationController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :ensure_user_in_session
  layout 'application'

  def show
    # 2要素認証入力画面
  end

  def verify
    user = User.find(session[:two_factor_user_id])

    otp_code = params[:otp_code] || params.dig(:user, :otp_code)
    backup_code = params[:backup_code] || params.dig(:user, :backup_code)

    if otp_code.present? && user.verify_otp(otp_code)
      complete_sign_in(user)
    elsif backup_code.present? && user.verify_backup_code(backup_code)
      complete_sign_in(user)
    else
      flash.now[:alert] = '認証コードまたはバックアップコードが正しくありません。'
      render :show, status: :unprocessable_entity
    end
  end

  private

  def ensure_user_in_session
    unless session[:two_factor_user_id]
      redirect_to new_user_session_path, alert: 'ログインが必要です。'
    end
  end

  def complete_sign_in(user)
    session.delete(:two_factor_user_id)
    sign_in(user)
    redirect_to after_sign_in_path_for(user), notice: 'ログインしました。'
  end
end
