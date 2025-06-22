# == Schema Information
#
# Table name: ten_major_stars
#
#  id          :integer          not null, primary key
#  description :text
#  name        :string           not null
#  yin_yang    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  element_id  :bigint           not null
#
# Indexes
#
#  index_ten_major_stars_on_element_id  (element_id)
#
# Foreign Keys
#
#  fk_rails_...  (element_id => elements.id)
#
class TenMajorStar < ApplicationRecord
  # 主観か客観かの性質で分かれている
  SELF_IDS = [2, 4, 6, 8, 10]
  OTHER_IDS = [1, 3, 5, 7, 9]
  # 構造化するためのID順
  STRUCTURE_IDS = [8, 7, 10, 9, 2, 1, 4, 3, 6, 5]

  belongs_to :element
  has_many :stem_ten_star_mappings
  has_many :main_stems, through: :stem_ten_star_mappings, source: :main_stem
  has_many :sub_stems, through: :stem_ten_star_mappings, source: :sub_stem

  enum :yin_yang, {
    '陰': 0,
    '陽': 1
  }

  def image_name
    case name
    when '貫索星'
      '木陽.png'
    when '石門星'
      '木陰.png'
    when '鳳閣星'
      '火陽.png'
    when '調舒星'
      '火陰.png'
    when '禄存星'
      '土陽.png'
    when '司禄星'
      '土陰.png'
    when '車騎星'
      '金陽.png'
    when '牽牛星'
      '金陰.png'
    when '龍高星'
      '水陽.png'
    when '玉堂星'
      '水陰.png'
    else
      nil
    end
  end
end
