class StemTenStarMapping < ApplicationRecord
  belongs_to :main_stem, class_name: 'Stem', foreign_key: 'main_stem_id'
  belongs_to :sub_stem, class_name: 'Stem', foreign_key: 'sub_stem_id'
  belongs_to :ten_major_star
end
