class PagesController < ApplicationController
  # 利用規約ページ・LPは認証不要
  skip_before_action :authenticate_user!, only: [:terms_of_service, :privacy_policy, :lp]

  def terms_of_service
  end

  def privacy_policy
  end

  def lp
  end
end
