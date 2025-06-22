# == Schema Information
#
# Table name: subscriptions
#
#  id                     :bigint           not null, primary key
#  amount                 :integer
#  end_date               :datetime
#  plan_name              :string
#  start_date             :datetime
#  status                 :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  stripe_customer_id     :string
#  stripe_subscription_id :string
#  user_id                :bigint           not null
#
# Indexes
#
#  index_subscriptions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
