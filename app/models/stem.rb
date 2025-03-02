class Stem < ApplicationRecord
  belongs_to :element
  has_many :branches_as_first_stem, class_name: 'Branch', foreign_key: 'first_stem_id'
  has_many :branches_as_second_stem, class_name: 'Branch', foreign_key: 'second_stem_id'
  has_many :branches_as_third_stem, class_name: 'Branch', foreign_key: 'third_stem_id'
  has_many :stem_ten_star_mappings_as_main_stem, class_name: 'StemTenStarMapping', foreign_key: 'main_stem_id'
  has_many :stem_ten_star_mappings_as_sub_stem, class_name: 'StemTenStarMapping', foreign_key: 'sub_stem_id'
  has_many :stem_twelve_star_mappings, class_name: 'StemTwelveStarMapping'

  enum :yin_yang, {
    '陰': 0,
    '陽': 1
  }

  def image_name
    case name
    when '甲'
      '甲木陽.png'
    when '乙'
      '乙木陰.png'
    when '丙'
      '丙火陽.png'
    when '丁'
      '丁火陰.png'
    when '戊'
      '戊土陽.png'
    when '己'
      '己土陰.png'
    when '庚'
      '庚金陽.png'
    when '辛'
      '辛金陰.png'
    when '壬'
      '壬水陽.png'
    when '癸'
      '癸水陰.png'
    else
      nil
    end
  end
end
