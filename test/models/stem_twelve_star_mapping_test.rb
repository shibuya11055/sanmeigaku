# == Schema Information
#
# Table name: stem_twelve_star_mappings(日干、十二支の十二大従星の関係)
#
#  id                             :integer          not null, primary key
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  branch_id(十二支)              :bigint           not null
#  stem_id(日干)                  :bigint           not null
#  twelve_sub_star_id(十二大従星) :bigint           not null
#
# Indexes
#
#  index_stem_twelve_star_mappings_on_branch_id           (branch_id)
#  index_stem_twelve_star_mappings_on_stem_id             (stem_id)
#  index_stem_twelve_star_mappings_on_twelve_sub_star_id  (twelve_sub_star_id)
#
# Foreign Keys
#
#  fk_rails_...  (branch_id => branches.id)
#  fk_rails_...  (stem_id => stems.id)
#  fk_rails_...  (twelve_sub_star_id => twelve_sub_stars.id)
#
require "test_helper"

class StemTwelveStarMappingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
