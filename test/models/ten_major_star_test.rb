# == Schema Information
#
# Table name: ten_major_stars
#
#  id          :integer          not null, primary key
#  description :text
#  name        :string           not null
#  yin_yang    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  element_id  :bigint           not null
#
# Indexes
#
#  index_ten_major_stars_on_element_id  (element_id)
#
# Foreign Keys
#
#  fk_rails_...  (element_id => elements.id)
#
require "test_helper"

class TenMajorStarTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
