class Stem < ApplicationRecord
  # 干合の組み合わせ
  STEM_UNIONS = {
    [1, 6].sort => [5, 6].sort,  # 甲己 <=> 戊己
    [3, 8].sort => [9, 10].sort, # 丙辛 <=> 壬癸
    [5, 10].sort => [3, 4].sort, # 戊癸 <=> 丙丁
    [7, 2].sort => [7, 8].sort,  # 庚乙 <=> 庚辛
    [9, 4].sort => [1, 2].sort   # 壬丁 <=> 甲乙
  }.freeze

  belongs_to :element
  has_many :branches_as_first_stem, class_name: 'Branch', foreign_key: 'first_stem_id'
  has_many :branches_as_second_stem, class_name: 'Branch', foreign_key: 'second_stem_id'
  has_many :branches_as_third_stem, class_name: 'Branch', foreign_key: 'third_stem_id'
  has_many :stem_ten_star_mappings_as_main_stem, class_name: 'StemTenStarMapping', foreign_key: 'main_stem_id'
  has_many :stem_ten_star_mappings_as_sub_stem, class_name: 'StemTenStarMapping', foreign_key: 'sub_stem_id'
  has_many :stem_twelve_star_mappings, class_name: 'StemTwelveStarMapping'

  # 原点六親
  has_many :stem_lineages_as_day, class_name: 'StemLineage', foreign_key: :day_stem_id
  has_many :stem_lineages_as_mother, class_name: 'StemLineage', foreign_key: :m_stem_id
  has_many :stem_lineages_as_father, class_name: 'StemLineage', foreign_key: :f_stem_id
  has_many :stem_lineages_as_m_gm, class_name: 'StemLineage', foreign_key: :m_grandmother_stem_id
  has_many :stem_lineages_as_m_gf, class_name: 'StemLineage', foreign_key: :m_grandfather_stem_id
  has_many :stem_lineages_as_f_gm, class_name: 'StemLineage', foreign_key: :f_grandmother_stem_id
  has_many :stem_lineages_as_f_gf, class_name: 'StemLineage', foreign_key: :f_grandfather_stem_id
  has_many :stem_lineages_as_spouse, class_name: 'StemLineage', foreign_key: :spouse_stem_id
  has_many :stem_lineages_as_m_in_law, class_name: 'StemLineage', foreign_key: :mother_in_law_stem_id
  has_many :stem_lineages_as_f_in_law, class_name: 'StemLineage', foreign_key: :father_in_law_stem_id
  has_many :stem_lineages_as_male_child, class_name: 'StemLineage', foreign_key: :male_child_stem_id
  has_many :stem_lineages_as_female_child, class_name: 'StemLineage', foreign_key: :female_child_stem_id
  has_many :stem_lineages_as_male_child_spouse, class_name: 'StemLineage', foreign_key: :male_child_spouse_stem_id
  has_many :stem_lineages_as_female_child_spouse, class_name: 'StemLineage', foreign_key: :female_child_spouse_stem_id

  enum :yin_yang, {
    '陰': 0,
    '陽': 1
  }

  # 干合
  def union_ids(first_stem_id, second_stem_id)
    input_pair = [first_stem_id, second_stem_id].sort

    STEM_UNIONS.each do |pair, result|
      if pair == input_pair
        return should_reverse?(result) ? result.reverse : result
      elsif result == input_pair
        return should_reverse?(pair) ? pair.reverse : pair
      end
    end

    nil
  end

  # 六親図で利用する干合する十干を返す
  def union_stem
    case id
    when 1, 6
      self.class.find(id == 1 ? 6 : 1)
    when 3, 8
      self.class.find(id == 3 ? 8 : 3)
    when 5, 10
      self.class.find(id == 5 ? 10 : 5)
    when 7, 2
      self.class.find(id == 7 ? 2 : 7)
    when 9, 4
      self.class.find(id == 9 ? 4 : 9)
    end
  end

  # 自分が生じる十干を返す
  def generates_stem
    target_element_id = element_id + 1
    target_element_id = 1 if target_element_id > 5
    target_yin_yang = yin_yang == '陽' ? '陰' : '陽'
    self.class.find_by(element_id: target_element_id, yin_yang: target_yin_yang)
  end

  # 自分を生じさせる十干を返す
  def generated_by_stem
    target_element_id = element_id - 1
    target_element_id = 5 if target_element_id.zero?
    target_yin_yang = yin_yang == '陽' ? '陰' : '陽'
    self.class.find_by(element_id: target_element_id, yin_yang: target_yin_yang)
  end

  def image_name
    case name
    when '甲'
      '木陽.png'
    when '乙'
      '木陰.png'
    when '丙'
      '火陽.png'
    when '丁'
      '火陰.png'
    when '戊'
      '土陽.png'
    when '己'
      '土陰.png'
    when '庚'
      '金陽.png'
    when '辛'
      '金陰.png'
    when '壬'
      '水陽.png'
    when '癸'
      '水陰.png'
    else
      'default.png'
    end
  end

  def yin_yang_convert
    case id
    when 1, 2
      self.class.find(id == 1 ? 2 : 1)
    when 3, 4
      self.class.find(id == 3 ? 4 : 3)
    when 5, 6
      self.class.find(id == 5 ? 6 : 5)
    when 7, 8
      self.class.find(id == 7 ? 8 : 7)
    when 9, 10
      self.class.find(id == 9 ? 10 : 9)
    end
  end

  private

  def should_reverse?(union)
    union == [2, 7] || union == [4, 9]
  end
end
