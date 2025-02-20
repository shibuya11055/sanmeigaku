class Stem < ApplicationRecord
  belongs_to :element
  has_many :branches_as_first_stem, class_name: 'Branch', foreign_key: 'first_stem_id'
  has_many :branches_as_second_stem, class_name: 'Branch', foreign_key: 'second_stem_id'
  has_many :branches_as_third_stem, class_name: 'Branch', foreign_key: 'third_stem_id'
  has_many :stem_ten_star_mappings_as_main_stem, class_name: 'StemTenStarMapping', foreign_key: 'main_stem_id'
  has_many :stem_ten_star_mappings_as_sub_stem, class_name: 'StemTenStarMapping', foreign_key: 'sub_stem_id'
end
