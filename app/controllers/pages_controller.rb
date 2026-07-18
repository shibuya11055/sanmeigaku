class PagesController < ApplicationController
  def terms_of_service
  end

  def privacy_policy
  end

  def lp
    if user_signed_in?
      redirect_to clients_path
    end
  end
end
