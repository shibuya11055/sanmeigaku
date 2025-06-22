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
class TwelveSubStar < ApplicationRecord
  has_many :stem_twelve_star_mappings, class_name: 'StemTwelveStarMapping'
  has_many :branches, through: :stem_twelve_star_mappings
  has_many :stems, through: :stem_twelve_star_mappings
end
