class TenMajorStar < ApplicationRecord
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
      '甲木陽.png'
    when '石門星'
      '乙木陰.png'
    when '鳳閣星'
      '丙火陽.png'
    when '調舒星'
      '丁火陰.png'
    when '禄存星'
      '戊土陽.png'
    when '司禄星'
      '己土陰.png'
    when '車騎星'
      '庚金陽.png'
    when '牽牛星'
      '辛金陰.png'
    when '龍高星'
      '壬水陽.png'
    when '玉堂星'
      '癸水陰.png'
    else
      nil
    end
  end
end
