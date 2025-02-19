class Stem < ApplicationRecord
  belongs_to :element
  has_many :branches_as_first_stem, class_name: 'Branch', foreign_key: 'first_stem_id'
  has_many :branches_as_second_stem, class_name: 'Branch', foreign_key: 'second_stem_id'
  has_many :branches_as_third_stem, class_name: 'Branch', foreign_key: 'third_stem_id'
end
