# == Schema Information
#
# Table name: branches
#
#  id                     :integer          not null, primary key
#  description            :text
#  first_stem_period_day  :integer
#  name                   :string           not null
#  second_stem_period_day :integer
#  third_stem_period_day  :integer
#  yin_yang               :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  element_id             :bigint           not null
#  first_stem_id          :bigint
#  second_stem_id         :bigint
#  third_stem_id          :bigint
#
# Indexes
#
#  index_branches_on_element_id      (element_id)
#  index_branches_on_first_stem_id   (first_stem_id)
#  index_branches_on_second_stem_id  (second_stem_id)
#  index_branches_on_third_stem_id   (third_stem_id)
#
# Foreign Keys
#
#  fk_rails_...  (element_id => elements.id)
#  fk_rails_...  (first_stem_id => stems.id)
#  fk_rails_...  (second_stem_id => stems.id)
#  fk_rails_...  (third_stem_id => stems.id)
#
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
