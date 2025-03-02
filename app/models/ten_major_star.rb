class TenMajorStar < ApplicationRecord
  belongs_to :element
  has_many :stem_ten_star_mappings
  has_many :main_stems, through: :stem_ten_star_mappings, source: :main_stem
  has_many :sub_stems, through: :stem_ten_star_mappings, source: :sub_stem

  enum :yin_yang, {
    '陰': 0,
    '陽': 1
  }
end
