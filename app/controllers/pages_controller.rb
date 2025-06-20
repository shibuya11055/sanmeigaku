class PagesController < ApplicationController
  # 利用規約ページは認証不要
  skip_before_action :authenticate_user!, only: [:terms_of_service, :privacy_policy]

  def terms_of_service
  end

  def privacy_policy
  end
end
