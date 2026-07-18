require 'test_helper'

class Users::PasswordResetRoutesTest < ActionDispatch::IntegrationTest
  test 'password reset routes are unavailable' do
    route_names = Rails.application.routes.named_routes.names

    assert_not_includes route_names, :new_user_password
    assert_not_includes route_names, :user_password
  end
end
