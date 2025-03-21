class StemLineage < ApplicationRecord
  belongs_to :day_stem, class_name: 'Stem'
  belongs_to :m_stem, class_name: 'Stem'
  belongs_to :f_stem, class_name: 'Stem'
  belongs_to :m_grandmother_stem, class_name: 'Stem'
  belongs_to :m_grandfather_stem, class_name: 'Stem'
  belongs_to :f_grandmother_stem, class_name: 'Stem'
  belongs_to :f_grandfather_stem, class_name: 'Stem'
  belongs_to :spouse_stem, class_name: 'Stem'
  belongs_to :mother_in_law_stem, class_name: 'Stem'
  belongs_to :father_in_law_stem, class_name: 'Stem'
  belongs_to :child_stem, class_name: 'Stem'

  enum :gender, {
    'male': 0,
    'female': 1
  }
end
