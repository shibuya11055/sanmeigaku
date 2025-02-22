class TwelveSubStar < ApplicationRecord
  has_many :stem_twelve_star_mappings, class_name: 'StemTwelveStarMapping'
  has_many :branches, through: :stem_twelve_star_mappings
  has_many :stems, through: :stem_twelve_star_mappings
end
