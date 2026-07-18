require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'public pages require authentication' do
    [root_path, lp_path, terms_of_service_path, privacy_policy_path].each do |path|
      get path

      assert_redirected_to new_user_session_path
    end
  end

  test 'authenticated user can access content pages' do
    user = User.create!(
      email: 'pages@example.com',
      fullname: 'ページ確認ユーザー',
      password: 'password123'
    )
    post user_session_path, params: {
      user: { email: user.email, password: 'password123' }
    }

    get terms_of_service_path
    assert_response :success

    get privacy_policy_path
    assert_response :success
  end
end
