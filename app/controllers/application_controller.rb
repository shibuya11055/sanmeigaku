class ApplicationController < ActionController::Base
  # 基本的に全てのページで認証を要求（Deviseの認証関連ページを除く）
  before_action :authenticate_user!, unless: :skip_authenticate?
  before_action :basic_auth, if: -> { Rails.env.production? }
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  # Deviseの認証関連ページでは認証をスキップ
  def skip_authenticate?
    devise_controller? && !%w[edit update destroy].include?(action_name)
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

  # Deviseのストロングパラメーター設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fullname])
    devise_parameter_sanitizer.permit(:account_update, keys: [:fullname])
  end
end
