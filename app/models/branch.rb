class Branch < ApplicationRecord
  belongs_to :element
  belongs_to :first_stem, class_name: 'Stem', foreign_key: 'first_stem_id', optional: true
  belongs_to :second_stem, class_name: 'Stem', foreign_key: 'second_stem_id', optional: true
  belongs_to :third_stem, class_name: 'Stem', foreign_key: 'third_stem_id', optional: true
  has_many :stem_twelve_star_mappings, class_name: 'StemTwelveStarMapping'

  def stem_ids
    [first_stem&.id, second_stem&.id, third_stem&.id]
  end
end
