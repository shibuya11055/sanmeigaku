class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :basic_auth, if: -> { Rails.env.production? }

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end
end
