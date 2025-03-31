class Branch < ApplicationRecord
  include PhaseRelationship

  belongs_to :element
  belongs_to :first_stem, class_name: 'Stem', foreign_key: 'first_stem_id', optional: true
  belongs_to :second_stem, class_name: 'Stem', foreign_key: 'second_stem_id', optional: true
  belongs_to :third_stem, class_name: 'Stem', foreign_key: 'third_stem_id', optional: true
  has_many :stem_twelve_star_mappings, class_name: 'StemTwelveStarMapping'

  def stem_ids
    [first_stem&.id, second_stem&.id, third_stem&.id]
  end

  def image_name
    case name
    when '子' then '水陰.png'
    when '丑' then '土陰.png'
    when '寅' then '木陽.png'
    when '卯' then '木陰.png'
    when '辰' then '土陽.png'
    when '巳' then '火陽.png'
    when '午' then '火陽.png'
    when '未' then '土陰.png'
    when '申' then '金陽.png'
    when '酉' then '金陰.png'
    when '戌' then '土陽.png'
    when '亥' then '水陽.png'
    else 'default.png'
    end
  end
end
