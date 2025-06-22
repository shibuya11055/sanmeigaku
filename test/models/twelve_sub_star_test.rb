# == Schema Information
#
# Table name: twelve_sub_stars
#
#  id                   :integer          not null, primary key
#  description          :text
#  energy(エネルギー値) :integer          not null
#  name                 :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require "test_helper"

class TwelveSubStarTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
