elements = [
  { name: '木', description: '成長、生命力、柔軟性を象徴する。' },
  { name: '火', description: '情熱、エネルギー、変革を象徴する。' },
  { name: '土', description: '安定、基盤、育成を象徴する。' },
  { name: '金', description: '強さ、構造、規律を象徴する。' },
  { name: '水', description: '知恵、適応力、流れを象徴する。' }
]

Element.create(elements)

ten_major_stars = [
  { name: '貫索星', yin_yang: 1, element_id: 1 },
  { name: '石門星', yin_yang: 0, element_id: 1 },
  { name: '鳳閣星', yin_yang: 1, element_id: 2 },
  { name: '調舒星', yin_yang: 0, element_id: 2 },
  { name: '禄存星', yin_yang: 1, element_id: 3 },
  { name: '司禄星', yin_yang: 0, element_id: 3 },
  { name: '車騎星', yin_yang: 1, element_id: 4 },
  { name: '牽牛星', yin_yang: 0, element_id: 4 },  
  { name: '龍高星', yin_yang: 1, element_id: 5 },
  { name: '玉堂星', yin_yang: 0, element_id: 5 },
]

TenMajorStar.create(ten_major_stars)

heavenly_stems = [
  { name: "甲", yin_yang: 1, element_id: 1, description: "大樹のような性質。堅実で忍耐強い。" },
  { name: "乙", yin_yang: 0, element_id: 1, description: "草花のように柔軟で繊細。" },
  { name: "丙", yin_yang: 1, element_id: 2, description: "太陽のように明るく情熱的。" },
  { name: "丁", yin_yang: 0, element_id: 2, description: "灯火のように温かく繊細。" },
  { name: "戊", yin_yang: 1, element_id: 3, description: "山のようにどっしりとした安定感。" },
  { name: "己", yin_yang: 0, element_id: 3, description: "田畑の土のように柔軟で養育的。" },
  { name: "庚", yin_yang: 1, element_id: 4, description: "鋼鉄のように強固で意志が強い。" },
  { name: "辛", yin_yang: 0, element_id: 4, description: "宝石のように繊細で美しい。" },
  { name: "壬", yin_yang: 1, element_id: 5, description: "大海のように広く包容力がある。" },
  { name: "癸", yin_yang: 0, element_id: 5, description: "雨水のように繊細で柔軟。" }
]

HeavenlyStem.create(heavenly_stems)

earthly_branches = [
  { name: '子', yin_yang: 1, element_id: 5, description: '冬の始まりを示し、知恵と適応力を象徴する。', third_stem_id: 10 },
  { name: '丑', yin_yang: 0, element_id: 3, description: '冬の終わりを示し、忍耐と安定を象徴する。', first_stem_id: 10, first_stem_period_day: 9, second_stem_id: 8, second_stem_period_day: 12, third_stem_id: 2},
  { name: '寅', yin_yang: 1, element_id: 1, description: '春の始まりを示し、成長と活力を象徴する。', first_stem_id:5, first_stem_period_day: 7, second_stem_id: 3, second_stem_period_day: 14, third_stem_id: 1 },
  { name: '卯', yin_yang: 0, element_id: 1, description: '春の盛りを示し、強い生命力と希望を象徴する。', third_stem_id: 2 },
  { name: '辰', yin_yang: 1, element_id: 3, description: '春の終わりを示し、変化と適応を象徴する。', first_stem_id: 2, first_stem_period_day: 9, second_stem_id: 10, second_stem_period_day: 12, third_stem_id: 5 },
  { name: '巳', yin_yang: 0, element_id: 2, description: '夏の始まりを示し、情熱と創造力を象徴する。', first_stem_id: 5, first_stem_period_day: 5, second_stem_id: 7, second_stem_period_day: 14, third_stem_id: 3 },
  { name: '午', yin_yang: 1, element_id: 2, description: '夏の盛りを示し、エネルギーと決断力を象徴する。', second_stem_id: 6, second_stem_period_day: 19, third_stem_id: 4 },
  { name: '未', yin_yang: 0, element_id: 3, description: '夏の終わりを示し、穏やかさと調和を象徴する。', first_stem_id: 4, first_stem_period_day: 9, second_stem_id: 2, second_stem_period_day: 12, third_stem_id: 6 },
  { name: '申', yin_yang: 1, element_id: 4, description: '秋の始まりを示し、知性と戦略を象徴する。', first_stem_id: 5, first_stem_period_day: 10, second_stem_id: 9, second_stem_period_day: 13, third_stem_id: 7 },
  { name: '酉', yin_yang: 0, element_id: 4, description: '秋の盛りを示し、収穫と完成を象徴する。', first_stem_id: 8 },
  { name: '戌', yin_yang: 1, element_id: 3, description: '秋の終わりを示し、誠実と忠誠を象徴する。', first_stem_id: 8, first_stem_period_day: 9, second_stem_id: 4, second_stem_period_day: 12, third_stem_id: 5 },
  { name: '亥', yin_yang: 0, element_id: 5, description: '冬の盛りを示し、静寂と再生を象徴する。', second_stem_id: 1, second_stem_period_day: 12, third_stem_id: 9 }
]

EarthlyBranch.create(earthly_branches)

sexagenary_cycles = [
  { number: 1, name: '甲子', heavenly_stem_id: 1, earthly_branch_id: 1, heavenly_void: 0  },
  { number: 2, name: '乙丑', heavenly_stem_id: 2, earthly_branch_id: 2, heavenly_void: 0  },
  { number: 3, name: '丙寅', heavenly_stem_id: 3, earthly_branch_id: 3, heavenly_void: 0  },
  { number: 4, name: '丁卯', heavenly_stem_id: 4, earthly_branch_id: 4, heavenly_void: 0  },
  { number: 5, name: '戊辰', heavenly_stem_id: 5, earthly_branch_id: 5, heavenly_void: 0  },
  { number: 6, name: '己巳', heavenly_stem_id: 6, earthly_branch_id: 6, heavenly_void: 0  },
  { number: 7, name: '庚午', heavenly_stem_id: 7, earthly_branch_id: 7, heavenly_void: 0  },
  { number: 8, name: '辛未', heavenly_stem_id: 8, earthly_branch_id: 8, heavenly_void: 0  },
  { number: 9, name: '壬申', heavenly_stem_id: 9, earthly_branch_id: 9, heavenly_void: 0  },
  { number: 10, name: '癸酉', heavenly_stem_id: 10, earthly_branch_id: 10, heavenly_void: 0 },
  { number: 11, name: '甲戌', heavenly_stem_id: 1, earthly_branch_id: 11, heavenly_void: 1 },
  { number: 12, name: '乙亥', heavenly_stem_id: 2, earthly_branch_id: 12, heavenly_void: 1 },
  { number: 13, name: '丙子', heavenly_stem_id: 3, earthly_branch_id: 1, heavenly_void:1 },
  { number: 14, name: '丁丑', heavenly_stem_id: 4, earthly_branch_id: 2, heavenly_void:1 },
  { number: 15, name: '戊寅', heavenly_stem_id: 5, earthly_branch_id: 3, heavenly_void:1 },
  { number: 16, name: '己卯', heavenly_stem_id: 6, earthly_branch_id: 4, heavenly_void:1 },
  { number: 17, name: '庚辰', heavenly_stem_id: 7, earthly_branch_id: 5, heavenly_void:1 },
  { number: 18, name: '辛巳', heavenly_stem_id: 8, earthly_branch_id: 6, heavenly_void:1 },
  { number: 19, name: '壬午', heavenly_stem_id: 9, earthly_branch_id: 7, heavenly_void:1 },
  { number: 20, name: '癸未', heavenly_stem_id: 10, earthly_branch_id: 8, heavenly_void: 1 },
  { number: 21, name: '甲申', heavenly_stem_id: 1, earthly_branch_id: 9, heavenly_void: 2 },
  { number: 22, name: '乙酉', heavenly_stem_id: 2, earthly_branch_id: 10, heavenly_void: 2 },
  { number: 23, name: '丙戌', heavenly_stem_id: 3, earthly_branch_id: 11, heavenly_void: 2 },
  { number: 24, name: '丁亥', heavenly_stem_id: 4, earthly_branch_id: 12, heavenly_void: 2 },
  { number: 25, name: '戊子', heavenly_stem_id: 5, earthly_branch_id: 1, heavenly_void: 2 },
  { number: 26, name: '己丑', heavenly_stem_id: 6, earthly_branch_id: 2, heavenly_void: 2 },
  { number: 27, name: '庚寅', heavenly_stem_id: 7, earthly_branch_id: 3, heavenly_void: 2 },
  { number: 28, name: '辛卯', heavenly_stem_id: 8, earthly_branch_id: 4, heavenly_void: 2 },
  { number: 29, name: '壬辰', heavenly_stem_id: 9, earthly_branch_id: 5, heavenly_void: 2 },
  { number: 30, name: '癸巳', heavenly_stem_id: 10, earthly_branch_id: 6, heavenly_void: 2 },
  { number: 31, name: '甲午', heavenly_stem_id: 1, earthly_branch_id: 7, heavenly_void: 3 },
  { number: 32, name: '乙未', heavenly_stem_id: 2, earthly_branch_id: 8, heavenly_void: 3 },
  { number: 33, name: '丙申', heavenly_stem_id: 3, earthly_branch_id: 9, heavenly_void: 3 },
  { number: 34, name: '丁酉', heavenly_stem_id: 4, earthly_branch_id: 10, heavenly_void: 3 },
  { number: 35, name: '戊戌', heavenly_stem_id: 5, earthly_branch_id: 11, heavenly_void: 3 },
  { number: 36, name: '己亥', heavenly_stem_id: 6, earthly_branch_id: 12, heavenly_void: 3 },
  { number: 37, name: '庚子', heavenly_stem_id: 7, earthly_branch_id: 1, heavenly_void: 3 },
  { number: 38, name: '辛丑', heavenly_stem_id: 8, earthly_branch_id: 2, heavenly_void: 3 },
  { number: 39, name: '壬寅', heavenly_stem_id: 9, earthly_branch_id: 3, heavenly_void: 3 },
  { number: 40, name: '癸卯', heavenly_stem_id: 10, earthly_branch_id: 4, heavenly_void: 3 },
  { number: 41, name: '甲辰', heavenly_stem_id: 1, earthly_branch_id: 5, heavenly_void: 4 },
  { number: 42, name: '乙巳', heavenly_stem_id: 2, earthly_branch_id: 6, heavenly_void: 4 },
  { number: 43, name: '丙午', heavenly_stem_id: 3, earthly_branch_id: 7, heavenly_void: 4 },
  { number: 44, name: '丁未', heavenly_stem_id: 4, earthly_branch_id: 8, heavenly_void: 4 },
  { number: 45, name: '戊申', heavenly_stem_id: 5, earthly_branch_id: 9, heavenly_void: 4 },
  { number: 46, name: '己酉', heavenly_stem_id: 6, earthly_branch_id: 10, heavenly_void: 4 },
  { number: 47, name: '庚戌', heavenly_stem_id: 7, earthly_branch_id: 11, heavenly_void: 4 },
  { number: 48, name: '辛亥', heavenly_stem_id: 8, earthly_branch_id: 12, heavenly_void: 4 },
  { number: 49, name: '壬子', heavenly_stem_id: 9, earthly_branch_id: 1, heavenly_void: 4 },
  { number: 50, name: '癸丑', heavenly_stem_id: 10, earthly_branch_id: 2, heavenly_void: 4 },
  { number: 51, name: '甲寅', heavenly_stem_id: 1, earthly_branch_id: 3, heavenly_void: 5 },
  { number: 52, name: '乙卯', heavenly_stem_id: 2, earthly_branch_id: 4, heavenly_void: 5 },
  { number: 53, name: '丙辰', heavenly_stem_id: 3, earthly_branch_id: 5, heavenly_void: 5 },
  { number: 54, name: '丁巳', heavenly_stem_id: 4, earthly_branch_id: 6, heavenly_void: 5 },
  { number: 55, name: '戊午', heavenly_stem_id: 5, earthly_branch_id: 7, heavenly_void: 5 },
  { number: 56, name: '己未', heavenly_stem_id: 6, earthly_branch_id: 8, heavenly_void: 5 },
  { number: 57, name: '庚申', heavenly_stem_id: 7, earthly_branch_id: 9, heavenly_void: 5 },
  { number: 58, name: '辛酉', heavenly_stem_id: 8, earthly_branch_id: 10, heavenly_void: 5 },
  { number: 59, name: '壬戌', heavenly_stem_id: 9, earthly_branch_id: 11, heavenly_void: 5 },
  { number: 60, name: '癸亥', heavenly_stem_id: 10, earthly_branch_id: 12, heavenly_void: 5 }
]

SexagenaryCycle.create(sexagenary_cycles)