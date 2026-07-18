require 'test_helper'

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test 'registration activates and signs in user without confirmation email' do
    assert_no_emails do
      assert_difference('User.count', 1) do
        post user_registration_path, params: {
          user: {
            email: 'registered@example.com',
            fullname: '登録ユーザー',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end
    end

    assert_redirected_to root_path

    get user_path
    assert_response :success
  end
end
