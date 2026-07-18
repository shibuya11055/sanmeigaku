# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  backup_codes        :text
#  email               :string           default(""), not null
#  encrypted_password  :string           default(""), not null
#  fullname            :string
#  otp_enabled         :boolean          default(FALSE), not null
#  otp_secret          :string
#  remember_created_at :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'email confirmation is not required' do
    user = User.new(
      email: 'user@example.com',
      fullname: '確認不要ユーザー',
      password: 'password123'
    )

    assert user.valid?
    assert user.active_for_authentication?
    assert_not_includes User.devise_modules, :confirmable
    assert_not_includes User.devise_modules, :recoverable
  end
end
