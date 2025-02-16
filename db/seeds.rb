elements = [
  { id: 1, name: '木', description: '成長、生命力、柔軟性を象徴する。' },
  { id: 2, name: '火', description: '情熱、エネルギー、変革を象徴する。' },
  { id: 3, name: '土', description: '安定、基盤、育成を象徴する。' },
  { id: 4, name: '金', description: '強さ、構造、規律を象徴する。' },
  { id: 5, name: '水', description: '知恵、適応力、流れを象徴する。' }
]

Element.create(elements)

ten_major_stars = [
  { id: 1, name: '貫索星', yin_yang: 1, element_id: 1 },
  { id: 2, name: '石門星', yin_yang: 0, element_id: 1 },
  { id: 3, name: '鳳閣星', yin_yang: 1, element_id: 2 },
  { id: 4, name: '調舒星', yin_yang: 0, element_id: 2 },
  { id: 5, name: '禄存星', yin_yang: 1, element_id: 3 },
  { id: 6, name: '司禄星', yin_yang: 0, element_id: 3 },
  { id: 7, name: '車騎星', yin_yang: 1, element_id: 4 },
  { id: 8, name: '牽牛星', yin_yang: 0, element_id: 4 },  
  { id: 9, name: '龍高星', yin_yang: 1, element_id: 5 },
  { id: 10, name: '玉堂星', yin_yang: 0, element_id: 5 },
]

TenMajorStar.create(ten_major_stars)

heavenly_stems = [
  { id: 1, name: "甲", yin_yang: 1, element_id: 1, description: "大樹のような性質。堅実で忍耐強い。" },
  { id: 2, name: "乙", yin_yang: 0, element_id: 1, description: "草花のように柔軟で繊細。" },
  { id: 3, name: "丙", yin_yang: 1, element_id: 2, description: "太陽のように明るく情熱的。" },
  { id: 4, name: "丁", yin_yang: 0, element_id: 2, description: "灯火のように温かく繊細。" },
  { id: 5, name: "戊", yin_yang: 1, element_id: 3, description: "山のようにどっしりとした安定感。" },
  { id: 6, name: "己", yin_yang: 0, element_id: 3, description: "田畑の土のように柔軟で養育的。" },
  { id: 7, name: "庚", yin_yang: 1, element_id: 4, description: "鋼鉄のように強固で意志が強い。" },
  { id: 8, name: "辛", yin_yang: 0, element_id: 4, description: "宝石のように繊細で美しい。" },
  { id: 9, name: "壬", yin_yang: 1, element_id: 5, description: "大海のように広く包容力がある。" },
  { id: 10, name: "癸", yin_yang: 0, element_id: 5, description: "雨水のように繊細で柔軟。" }
]

Stem.create(heavenly_stems)

earthly_branches = [
  { id: 1, name: '子', yin_yang: 1, element_id: 5, description: '冬の始まりを示し、知恵と適応力を象徴する。', third_stem_id: 10 },
  { id: 2, name: '丑', yin_yang: 0, element_id: 3, description: '冬の終わりを示し、忍耐と安定を象徴する。', first_stem_id: 10, first_stem_period_day: 9, second_stem_id: 8, second_stem_period_day: 12, third_stem_id: 2},
  { id: 3, name: '寅', yin_yang: 1, element_id: 1, description: '春の始まりを示し、成長と活力を象徴する。', first_stem_id:5, first_stem_period_day: 7, second_stem_id: 3, second_stem_period_day: 14, third_stem_id: 1 },
  { id: 4, name: '卯', yin_yang: 0, element_id: 1, description: '春の盛りを示し、強い生命力と希望を象徴する。', third_stem_id: 2 },
  { id: 5, name: '辰', yin_yang: 1, element_id: 3, description: '春の終わりを示し、変化と適応を象徴する。', first_stem_id: 2, first_stem_period_day: 9, second_stem_id: 10, second_stem_period_day: 12, third_stem_id: 5 },
  { id: 6, name: '巳', yin_yang: 0, element_id: 2, description: '夏の始まりを示し、情熱と創造力を象徴する。', first_stem_id: 5, first_stem_period_day: 5, second_stem_id: 7, second_stem_period_day: 14, third_stem_id: 3 },
  { id: 7, name: '午', yin_yang: 1, element_id: 2, description: '夏の盛りを示し、エネルギーと決断力を象徴する。', second_stem_id: 6, second_stem_period_day: 19, third_stem_id: 4 },
  { id: 8, name: '未', yin_yang: 0, element_id: 3, description: '夏の終わりを示し、穏やかさと調和を象徴する。', first_stem_id: 4, first_stem_period_day: 9, second_stem_id: 2, second_stem_period_day: 12, third_stem_id: 6 },
  { id: 9, name: '申', yin_yang: 1, element_id: 4, description: '秋の始まりを示し、知性と戦略を象徴する。', first_stem_id: 5, first_stem_period_day: 10, second_stem_id: 9, second_stem_period_day: 13, third_stem_id: 7 },
  { id: 10, name: '酉', yin_yang: 0, element_id: 4, description: '秋の盛りを示し、収穫と完成を象徴する。', first_stem_id: 8 },
  { id: 11, name: '戌', yin_yang: 1, element_id: 3, description: '秋の終わりを示し、誠実と忠誠を象徴する。', first_stem_id: 8, first_stem_period_day: 9, second_stem_id: 4, second_stem_period_day: 12, third_stem_id: 5 },
  { id: 12, name: '亥', yin_yang: 0, element_id: 5, description: '冬の盛りを示し、静寂と再生を象徴する。', second_stem_id: 1, second_stem_period_day: 12, third_stem_id: 9 }
]

Branch.create(earthly_branches)

sexagenary_cycles = [
  { id: 1, name: '甲子', stem_id: 1, branch_id: 1, heavenly_void: 0  },
  { id: 2, name: '乙丑', stem_id: 2, branch_id: 2, heavenly_void: 0  },
  { id: 3, name: '丙寅', stem_id: 3, branch_id: 3, heavenly_void: 0  },
  { id: 4, name: '丁卯', stem_id: 4, branch_id: 4, heavenly_void: 0  },
  { id: 5, name: '戊辰', stem_id: 5, branch_id: 5, heavenly_void: 0  },
  { id: 6, name: '己巳', stem_id: 6, branch_id: 6, heavenly_void: 0  },
  { id: 7, name: '庚午', stem_id: 7, branch_id: 7, heavenly_void: 0  },
  { id: 8, name: '辛未', stem_id: 8, branch_id: 8, heavenly_void: 0  },
  { id: 9, name: '壬申', stem_id: 9, branch_id: 9, heavenly_void: 0  },
  { id: 10, name: '癸酉', stem_id: 10, branch_id: 10, heavenly_void: 0 },
  { id: 11, name: '甲戌', stem_id: 1, branch_id: 11, heavenly_void: 1 },
  { id: 12, name: '乙亥', stem_id: 2, branch_id: 12, heavenly_void: 1 },
  { id: 13, name: '丙子', stem_id: 3, branch_id: 1, heavenly_void:1 },
  { id: 14, name: '丁丑', stem_id: 4, branch_id: 2, heavenly_void:1 },
  { id: 15, name: '戊寅', stem_id: 5, branch_id: 3, heavenly_void:1 },
  { id: 16, name: '己卯', stem_id: 6, branch_id: 4, heavenly_void:1 },
  { id: 17, name: '庚辰', stem_id: 7, branch_id: 5, heavenly_void:1 },
  { id: 18, name: '辛巳', stem_id: 8, branch_id: 6, heavenly_void:1 },
  { id: 19, name: '壬午', stem_id: 9, branch_id: 7, heavenly_void:1 },
  { id: 20, name: '癸未', stem_id: 10, branch_id: 8, heavenly_void: 1 },
  { id: 21, name: '甲申', stem_id: 1, branch_id: 9, heavenly_void: 2 },
  { id: 22, name: '乙酉', stem_id: 2, branch_id: 10, heavenly_void: 2 },
  { id: 23, name: '丙戌', stem_id: 3, branch_id: 11, heavenly_void: 2 },
  { id: 24, name: '丁亥', stem_id: 4, branch_id: 12, heavenly_void: 2 },
  { id: 25, name: '戊子', stem_id: 5, branch_id: 1, heavenly_void: 2 },
  { id: 26, name: '己丑', stem_id: 6, branch_id: 2, heavenly_void: 2 },
  { id: 27, name: '庚寅', stem_id: 7, branch_id: 3, heavenly_void: 2 },
  { id: 28, name: '辛卯', stem_id: 8, branch_id: 4, heavenly_void: 2 },
  { id: 29, name: '壬辰', stem_id: 9, branch_id: 5, heavenly_void: 2 },
  { id: 30, name: '癸巳', stem_id: 10, branch_id: 6, heavenly_void: 2 },
  { id: 31, name: '甲午', stem_id: 1, branch_id: 7, heavenly_void: 3 },
  { id: 32, name: '乙未', stem_id: 2, branch_id: 8, heavenly_void: 3 },
  { id: 33, name: '丙申', stem_id: 3, branch_id: 9, heavenly_void: 3 },
  { id: 34, name: '丁酉', stem_id: 4, branch_id: 10, heavenly_void: 3 },
  { id: 35, name: '戊戌', stem_id: 5, branch_id: 11, heavenly_void: 3 },
  { id: 36, name: '己亥', stem_id: 6, branch_id: 12, heavenly_void: 3 },
  { id: 37, name: '庚子', stem_id: 7, branch_id: 1, heavenly_void: 3 },
  { id: 38, name: '辛丑', stem_id: 8, branch_id: 2, heavenly_void: 3 },
  { id: 39, name: '壬寅', stem_id: 9, branch_id: 3, heavenly_void: 3 },
  { id: 40, name: '癸卯', stem_id: 10, branch_id: 4, heavenly_void: 3 },
  { id: 41, name: '甲辰', stem_id: 1, branch_id: 5, heavenly_void: 4 },
  { id: 42, name: '乙巳', stem_id: 2, branch_id: 6, heavenly_void: 4 },
  { id: 43, name: '丙午', stem_id: 3, branch_id: 7, heavenly_void: 4 },
  { id: 44, name: '丁未', stem_id: 4, branch_id: 8, heavenly_void: 4 },
  { id: 45, name: '戊申', stem_id: 5, branch_id: 9, heavenly_void: 4 },
  { id: 46, name: '己酉', stem_id: 6, branch_id: 10, heavenly_void: 4 },
  { id: 47, name: '庚戌', stem_id: 7, branch_id: 11, heavenly_void: 4 },
  { id: 48, name: '辛亥', stem_id: 8, branch_id: 12, heavenly_void: 4 },
  { id: 49, name: '壬子', stem_id: 9, branch_id: 1, heavenly_void: 4 },
  { id: 50, name: '癸丑', stem_id: 10, branch_id: 2, heavenly_void: 4 },
  { id: 51, name: '甲寅', stem_id: 1, branch_id: 3, heavenly_void: 5 },
  { id: 52, name: '乙卯', stem_id: 2, branch_id: 4, heavenly_void: 5 },
  { id: 53, name: '丙辰', stem_id: 3, branch_id: 5, heavenly_void: 5 },
  { id: 54, name: '丁巳', stem_id: 4, branch_id: 6, heavenly_void: 5 },
  { id: 55, name: '戊午', stem_id: 5, branch_id: 7, heavenly_void: 5 },
  { id: 56, name: '己未', stem_id: 6, branch_id: 8, heavenly_void: 5 },
  { id: 57, name: '庚申', stem_id: 7, branch_id: 9, heavenly_void: 5 },
  { id: 58, name: '辛酉', stem_id: 8, branch_id: 10, heavenly_void: 5 },
  { id: 59, name: '壬戌', stem_id: 9, branch_id: 11, heavenly_void: 5 },
  { id: 60, name: '癸亥', stem_id: 10, branch_id: 12, heavenly_void: 5 }
]

SexagenaryCycle.create(sexagenary_cycles)

require 'date'

start_date = Date.new(1925, 1, 1)
end_date = Date.new(2044, 12, 31)

(start_date..end_date).each do |date|
  FortuneAnalysisCalculator.call(date)
end