module StemConst
  extend ActiveSupport::Concern

  # 干合の組み合わせ
  STEM_UNIONS = {
    [1, 6].sort => [5, 6].sort,  # 甲己 <=> 戊己
    [3, 8].sort => [9, 10].sort, # 丙辛 <=> 壬癸
    [5, 10].sort => [3, 4].sort, # 戊癸 <=> 丙丁
    [7, 2].sort => [7, 8].sort,  # 庚乙 <=> 庚辛
    [9, 4].sort => [1, 2].sort   # 壬丁 <=> 甲乙
  }.freeze

  UNION_NAMES = [
    '甲己',
    '丙辛',
    '戊癸',
    '庚乙',
    '壬丁',
    '己甲',
    '辛丙',
    '癸戊',
    '乙庚',
    '丁壬'
  ]
end
