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
  belongs_to :male_child_stem, class_name: 'Stem'
  belongs_to :female_child_stem, class_name: 'Stem'
  belongs_to :male_child_spouse_stem, class_name: 'Stem'
  belongs_to :female_child_spouse_stem, class_name: 'Stem'

  def self.eager_load_all_stems
    eager_load(
      self.reflect_on_all_associations(:belongs_to).map(&:name)
    )
  end
end
