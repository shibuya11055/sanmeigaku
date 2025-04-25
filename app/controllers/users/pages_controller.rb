class Users::PagesController < ApplicationController
  # ログイン不要
  skip_before_action :authenticate_user!, if: :devise_controller?

  # メール送信完了ページ
  def mail_sent
    @email = params[:email]
    @action = params[:action_type] || 'confirmation'
  end
end
