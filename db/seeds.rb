elements = [
  { id: 1, name: '木', description: '成長、生命力、柔軟性を象徴する。' },
  { id: 2, name: '火', description: '情熱、エネルギー、変革を象徴する。' },
  { id: 3, name: '土', description: '安定、基盤、育成を象徴する。' },
  { id: 4, name: '金', description: '強さ、構造、規律を象徴する。' },
  { id: 5, name: '水', description: '知恵、適応力、流れを象徴する。' }
]

elements.each do |element|
  next if Element.exists?(id: element[:id])
  Element.create!(element)
end

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
  { id: 10, name: '玉堂星', yin_yang: 0, element_id: 5 }
]

ten_major_stars.each do |ten_major_star|
  next if TenMajorStar.exists?(id: ten_major_star[:id])
  TenMajorStar.create!(ten_major_star)
end

twelve_sub_stars = [
  { id: 1, name: '天報星', energy: 3 },
  { id: 2, name: '天印星', energy: 6 },
  { id: 3, name: '天貴星', energy: 9 },
  { id: 4, name: '天恍星', energy: 7 },
  { id: 5, name: '天南星', energy: 10 },
  { id: 6, name: '天禄星', energy: 11 },
  { id: 7, name: '天将星', energy: 12 },
  { id: 8, name: '天堂星', energy: 8 },
  { id: 9, name: '天胡星', energy: 4 },
  { id: 10, name: '天極星', energy: 2 },
  { id: 11, name: '天庫星', energy: 5 },
  { id: 12, name: '天馳星', energy: 1 }
]

twelve_sub_stars.each do |twelve_sub_star|
  next if TwelveSubStar.exists?(id: twelve_sub_star[:id])
  TwelveSubStar.create!(twelve_sub_star)
end

stems = [
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

stems.each do |stem|
  next if Stem.exists?(id: stem[:id])
  Stem.create!(stem)
end

# 原点六親
stem_lineages = [
  { id: 1, day_stem_id: 1,  m_stem_id: 10, f_stem_id: 5,  m_grandmother_stem_id: 7,  m_grandfather_stem_id: 2,  f_grandmother_stem_id: 4,  f_grandfather_stem_id: 9,  spouse_stem_id: 6,  mother_in_law_stem_id: 3,  father_in_law_stem_id: 8, male_child_stem_id: 2, female_child_stem_id: 4, male_child_spouse_stem_id: 2, female_child_spouse_stem_id: 9 },
  { id: 2, day_stem_id: 2,  m_stem_id: 9,  f_stem_id: 4,  m_grandmother_stem_id: 8,  m_grandfather_stem_id: 3,  f_grandmother_stem_id: 1,  f_grandfather_stem_id: 6,  spouse_stem_id: 7,  mother_in_law_stem_id: 6,  father_in_law_stem_id: 1, male_child_stem_id: 10, female_child_stem_id: 3, male_child_spouse_stem_id: 5, female_child_spouse_stem_id: 8 },
  { id: 3, day_stem_id: 3,  m_stem_id: 2,  f_stem_id: 7,  m_grandmother_stem_id: 9,  m_grandfather_stem_id: 4,  f_grandmother_stem_id: 6,  f_grandfather_stem_id: 1,  spouse_stem_id: 8,  mother_in_law_stem_id: 5,  father_in_law_stem_id: 10, male_child_stem_id: 9, female_child_stem_id: 6, male_child_spouse_stem_id: 4, female_child_spouse_stem_id: 1 },
  { id: 4, day_stem_id: 4,  m_stem_id: 1,  f_stem_id: 6,  m_grandmother_stem_id: 10, m_grandfather_stem_id: 5,  f_grandmother_stem_id: 3,  f_grandfather_stem_id: 8,  spouse_stem_id: 9,  mother_in_law_stem_id: 8,  father_in_law_stem_id: 3, male_child_stem_id: 2, female_child_stem_id: 5, male_child_spouse_stem_id: 7, female_child_spouse_stem_id: 10 },
  { id: 5, day_stem_id: 5,  m_stem_id: 4,  f_stem_id: 9,  m_grandmother_stem_id: 1,  m_grandfather_stem_id: 6,  f_grandmother_stem_id: 8,  f_grandfather_stem_id: 3,  spouse_stem_id: 10, mother_in_law_stem_id: 7,  father_in_law_stem_id: 2, male_child_stem_id: 1, female_child_stem_id: 8, male_child_spouse_stem_id: 6, female_child_spouse_stem_id: 3 },
  { id: 6, day_stem_id: 6,  m_stem_id: 3,  f_stem_id: 8,  m_grandmother_stem_id: 2,  m_grandfather_stem_id: 7,  f_grandmother_stem_id: 5,  f_grandfather_stem_id: 10, spouse_stem_id: 1,  mother_in_law_stem_id: 10, father_in_law_stem_id: 5, male_child_stem_id: 4, female_child_stem_id: 7, male_child_spouse_stem_id: 9, female_child_spouse_stem_id: 2 },
  { id: 7, day_stem_id: 7,  m_stem_id: 6,  f_stem_id: 1,  m_grandmother_stem_id: 3,  m_grandfather_stem_id: 8,  f_grandmother_stem_id: 10, f_grandfather_stem_id: 5,  spouse_stem_id: 2,  mother_in_law_stem_id: 9,  father_in_law_stem_id: 4, male_child_stem_id: 3, female_child_stem_id: 10, male_child_spouse_stem_id: 8, female_child_spouse_stem_id: 5 },
  { id: 8, day_stem_id: 8,  m_stem_id: 5,  f_stem_id: 10, m_grandmother_stem_id: 4,  m_grandfather_stem_id: 9,  f_grandmother_stem_id: 7,  f_grandfather_stem_id: 2,  spouse_stem_id: 3,  mother_in_law_stem_id: 2,  father_in_law_stem_id: 7, male_child_stem_id: 6, female_child_stem_id: 9, male_child_spouse_stem_id: 1, female_child_spouse_stem_id: 4 },
  { id: 9, day_stem_id: 9,  m_stem_id: 8,  f_stem_id: 3,  m_grandmother_stem_id: 5,  m_grandfather_stem_id: 10, f_grandmother_stem_id: 2,  f_grandfather_stem_id: 7,  spouse_stem_id: 4,  mother_in_law_stem_id: 1,  father_in_law_stem_id: 6, male_child_stem_id: 5, female_child_stem_id: 2, male_child_spouse_stem_id: 10, female_child_spouse_stem_id: 7 },
  { id: 10, day_stem_id: 10, m_stem_id: 7,  f_stem_id: 2,  m_grandmother_stem_id: 6,  m_grandfather_stem_id: 1,  f_grandmother_stem_id: 9,  f_grandfather_stem_id: 4,  spouse_stem_id: 5,  mother_in_law_stem_id: 4,  father_in_law_stem_id: 9, male_child_stem_id: 8, female_child_stem_id: 1, male_child_spouse_stem_id: 3, female_child_spouse_stem_id: 6 }
]

stem_lineages.each do |lineage|
  next if StemLineage.exists?(id: lineage[:id])

  StemLineage.create!(lineage)
end

branches = [
  { id: 1, name: '子', yin_yang: 0, element_id: 5, description: '冬の始まりを示し、知恵と適応力を象徴する。', third_stem_id: 10 },
  { id: 2, name: '丑', yin_yang: 0, element_id: 3, description: '冬の終わりを示し、忍耐と安定を象徴する。', first_stem_id: 10, first_stem_period_day: 9, second_stem_id: 8, second_stem_period_day: 12, third_stem_id: 6 },
  { id: 3, name: '寅', yin_yang: 1, element_id: 1, description: '春の始まりを示し、成長と活力を象徴する。', first_stem_id: 5, first_stem_period_day: 7, second_stem_id: 3, second_stem_period_day: 14, third_stem_id: 1 },
  { id: 4, name: '卯', yin_yang: 0, element_id: 1, description: '春の盛りを示し、強い生命力と希望を象徴する。', third_stem_id: 2 },
  { id: 5, name: '辰', yin_yang: 1, element_id: 3, description: '春の終わりを示し、変化と適応を象徴する。', first_stem_id: 2, first_stem_period_day: 9, second_stem_id: 10, second_stem_period_day: 12, third_stem_id: 5 },
  { id: 6, name: '巳', yin_yang: 1, element_id: 2, description: '夏の始まりを示し、情熱と創造力を象徴する。', first_stem_id: 5, first_stem_period_day: 5, second_stem_id: 7, second_stem_period_day: 14, third_stem_id: 3 },
  { id: 7, name: '午', yin_yang: 0, element_id: 2, description: '夏の盛りを示し、エネルギーと決断力を象徴する。', second_stem_id: 6, second_stem_period_day: 19, third_stem_id: 4 },
  { id: 8, name: '未', yin_yang: 0, element_id: 3, description: '夏の終わりを示し、穏やかさと調和を象徴する。', first_stem_id: 4, first_stem_period_day: 9, second_stem_id: 2, second_stem_period_day: 12, third_stem_id: 6 },
  { id: 9, name: '申', yin_yang: 1, element_id: 4, description: '秋の始まりを示し、知性と戦略を象徴する。', first_stem_id: 5, first_stem_period_day: 10, second_stem_id: 9, second_stem_period_day: 13, third_stem_id: 7 },
  { id: 10, name: '酉', yin_yang: 0, element_id: 4, description: '秋の盛りを示し、収穫と完成を象徴する。', third_stem_id: 8 },
  { id: 11, name: '戌', yin_yang: 1, element_id: 3, description: '秋の終わりを示し、誠実と忠誠を象徴する。', first_stem_id: 8, first_stem_period_day: 9, second_stem_id: 4, second_stem_period_day: 12, third_stem_id: 5 },
  { id: 12, name: '亥', yin_yang: 1, element_id: 5, description: '冬の盛りを示し、静寂と再生を象徴する。', second_stem_id: 1, second_stem_period_day: 12, third_stem_id: 9 }
]

branches.each do |branch|
  next if Branch.exists?(id: branch[:id])
  Branch.create!(branch)
end

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
  { id: 13, name: '丙子', stem_id: 3, branch_id: 1, heavenly_void: 1 },
  { id: 14, name: '丁丑', stem_id: 4, branch_id: 2, heavenly_void: 1 },
  { id: 15, name: '戊寅', stem_id: 5, branch_id: 3, heavenly_void: 1 },
  { id: 16, name: '己卯', stem_id: 6, branch_id: 4, heavenly_void: 1 },
  { id: 17, name: '庚辰', stem_id: 7, branch_id: 5, heavenly_void: 1 },
  { id: 18, name: '辛巳', stem_id: 8, branch_id: 6, heavenly_void: 1 },
  { id: 19, name: '壬午', stem_id: 9, branch_id: 7, heavenly_void: 1 },
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

sexagenary_cycles.each do |sexagenary_cycle|
  next if SexagenaryCycle.exists?(id: sexagenary_cycle[:id])
  SexagenaryCycle.create!(sexagenary_cycle)
end

stem_ten_star_mappings = [
  { id: 1, main_stem_id: 1, sub_stem_id: 1, ten_major_star_id: 1 },
  { id: 2, main_stem_id: 1, sub_stem_id: 2, ten_major_star_id: 2 },
  { id: 3, main_stem_id: 1, sub_stem_id: 3, ten_major_star_id: 3 },
  { id: 4, main_stem_id: 1, sub_stem_id: 4, ten_major_star_id: 4 },
  { id: 5, main_stem_id: 1, sub_stem_id: 5, ten_major_star_id: 5 },
  { id: 6, main_stem_id: 1, sub_stem_id: 6, ten_major_star_id: 6 },
  { id: 7, main_stem_id: 1, sub_stem_id: 7, ten_major_star_id: 7 },
  { id: 8, main_stem_id: 1, sub_stem_id: 8, ten_major_star_id: 8 },
  { id: 9, main_stem_id: 1, sub_stem_id: 9, ten_major_star_id: 9 },
  { id: 10, main_stem_id: 1, sub_stem_id: 10, ten_major_star_id: 10 },
  { id: 11, main_stem_id: 2, sub_stem_id: 2, ten_major_star_id: 1 },
  { id: 12, main_stem_id: 2, sub_stem_id: 1, ten_major_star_id: 2 },
  { id: 13, main_stem_id: 2, sub_stem_id: 4, ten_major_star_id: 3 },
  { id: 14, main_stem_id: 2, sub_stem_id: 3, ten_major_star_id: 4 },
  { id: 15, main_stem_id: 2, sub_stem_id: 6, ten_major_star_id: 5 },
  { id: 16, main_stem_id: 2, sub_stem_id: 5, ten_major_star_id: 6 },
  { id: 17, main_stem_id: 2, sub_stem_id: 8, ten_major_star_id: 7 },
  { id: 18, main_stem_id: 2, sub_stem_id: 7, ten_major_star_id: 8 },
  { id: 19, main_stem_id: 2, sub_stem_id: 10, ten_major_star_id: 9 },
  { id: 20, main_stem_id: 2, sub_stem_id: 9, ten_major_star_id: 10 },
  { id: 21, main_stem_id: 3, sub_stem_id: 3, ten_major_star_id: 1 },
  { id: 22, main_stem_id: 3, sub_stem_id: 4, ten_major_star_id: 2 },
  { id: 23, main_stem_id: 3, sub_stem_id: 5, ten_major_star_id: 3 },
  { id: 24, main_stem_id: 3, sub_stem_id: 6, ten_major_star_id: 4 },
  { id: 25, main_stem_id: 3, sub_stem_id: 7, ten_major_star_id: 5 },
  { id: 26, main_stem_id: 3, sub_stem_id: 8, ten_major_star_id: 6 },
  { id: 27, main_stem_id: 3, sub_stem_id: 9, ten_major_star_id: 7 },
  { id: 28, main_stem_id: 3, sub_stem_id: 10, ten_major_star_id: 8 },
  { id: 29, main_stem_id: 3, sub_stem_id: 1, ten_major_star_id: 9 },
  { id: 30, main_stem_id: 3, sub_stem_id: 2, ten_major_star_id: 10 },
  { id: 31, main_stem_id: 4, sub_stem_id: 4, ten_major_star_id: 1 },
  { id: 32, main_stem_id: 4, sub_stem_id: 3, ten_major_star_id: 2 },
  { id: 33, main_stem_id: 4, sub_stem_id: 6, ten_major_star_id: 3 },
  { id: 34, main_stem_id: 4, sub_stem_id: 5, ten_major_star_id: 4 },
  { id: 35, main_stem_id: 4, sub_stem_id: 8, ten_major_star_id: 5 },
  { id: 36, main_stem_id: 4, sub_stem_id: 7, ten_major_star_id: 6 },
  { id: 37, main_stem_id: 4, sub_stem_id: 10, ten_major_star_id: 7 },
  { id: 38, main_stem_id: 4, sub_stem_id: 9, ten_major_star_id: 8 },
  { id: 39, main_stem_id: 4, sub_stem_id: 2, ten_major_star_id: 9 },
  { id: 40, main_stem_id: 4, sub_stem_id: 1, ten_major_star_id: 10 },
  { id: 41, main_stem_id: 5, sub_stem_id: 5, ten_major_star_id: 1 },
  { id: 42, main_stem_id: 5, sub_stem_id: 6, ten_major_star_id: 2 },
  { id: 43, main_stem_id: 5, sub_stem_id: 7, ten_major_star_id: 3 },
  { id: 44, main_stem_id: 5, sub_stem_id: 8, ten_major_star_id: 4 },
  { id: 45, main_stem_id: 5, sub_stem_id: 9, ten_major_star_id: 5 },
  { id: 46, main_stem_id: 5, sub_stem_id: 10, ten_major_star_id: 6 },
  { id: 47, main_stem_id: 5, sub_stem_id: 1, ten_major_star_id: 7 },
  { id: 48, main_stem_id: 5, sub_stem_id: 2, ten_major_star_id: 8 },
  { id: 49, main_stem_id: 5, sub_stem_id: 3, ten_major_star_id: 9 },
  { id: 50, main_stem_id: 5, sub_stem_id: 4, ten_major_star_id: 10 },
  { id: 51, main_stem_id: 6, sub_stem_id: 6, ten_major_star_id: 1 },
  { id: 52, main_stem_id: 6, sub_stem_id: 5, ten_major_star_id: 2 },
  { id: 53, main_stem_id: 6, sub_stem_id: 8, ten_major_star_id: 3 },
  { id: 54, main_stem_id: 6, sub_stem_id: 7, ten_major_star_id: 4 },
  { id: 55, main_stem_id: 6, sub_stem_id: 10, ten_major_star_id: 5 },
  { id: 56, main_stem_id: 6, sub_stem_id: 9, ten_major_star_id: 6 },
  { id: 57, main_stem_id: 6, sub_stem_id: 2, ten_major_star_id: 7 },
  { id: 58, main_stem_id: 6, sub_stem_id: 1, ten_major_star_id: 8 },
  { id: 59, main_stem_id: 6, sub_stem_id: 4, ten_major_star_id: 9 },
  { id: 60, main_stem_id: 6, sub_stem_id: 3, ten_major_star_id: 10 },
  { id: 61, main_stem_id: 7, sub_stem_id: 7, ten_major_star_id: 1 },
  { id: 62, main_stem_id: 7, sub_stem_id: 8, ten_major_star_id: 2 },
  { id: 63, main_stem_id: 7, sub_stem_id: 9, ten_major_star_id: 3 },
  { id: 64, main_stem_id: 7, sub_stem_id: 10, ten_major_star_id: 4 },
  { id: 65, main_stem_id: 7, sub_stem_id: 1, ten_major_star_id: 5 },
  { id: 66, main_stem_id: 7, sub_stem_id: 2, ten_major_star_id: 6 },
  { id: 67, main_stem_id: 7, sub_stem_id: 3, ten_major_star_id: 7 },
  { id: 68, main_stem_id: 7, sub_stem_id: 4, ten_major_star_id: 8 },
  { id: 69, main_stem_id: 7, sub_stem_id: 5, ten_major_star_id: 9 },
  { id: 70, main_stem_id: 7, sub_stem_id: 6, ten_major_star_id: 10 },
  { id: 71, main_stem_id: 8, sub_stem_id: 8, ten_major_star_id: 1 },
  { id: 72, main_stem_id: 8, sub_stem_id: 7, ten_major_star_id: 2 },
  { id: 73, main_stem_id: 8, sub_stem_id: 10, ten_major_star_id: 3 },
  { id: 74, main_stem_id: 8, sub_stem_id: 9, ten_major_star_id: 4 },
  { id: 75, main_stem_id: 8, sub_stem_id: 2, ten_major_star_id: 5 },
  { id: 76, main_stem_id: 8, sub_stem_id: 1, ten_major_star_id: 6 },
  { id: 77, main_stem_id: 8, sub_stem_id: 4, ten_major_star_id: 7 },
  { id: 78, main_stem_id: 8, sub_stem_id: 3, ten_major_star_id: 8 },
  { id: 79, main_stem_id: 8, sub_stem_id: 6, ten_major_star_id: 9 },
  { id: 80, main_stem_id: 8, sub_stem_id: 5, ten_major_star_id: 10 },
  { id: 81, main_stem_id: 9, sub_stem_id: 9, ten_major_star_id: 1 },
  { id: 82, main_stem_id: 9, sub_stem_id: 10, ten_major_star_id: 2 },
  { id: 83, main_stem_id: 9, sub_stem_id: 1, ten_major_star_id: 3 },
  { id: 84, main_stem_id: 9, sub_stem_id: 2, ten_major_star_id: 4 },
  { id: 85, main_stem_id: 9, sub_stem_id: 3, ten_major_star_id: 5 },
  { id: 86, main_stem_id: 9, sub_stem_id: 4, ten_major_star_id: 6 },
  { id: 87, main_stem_id: 9, sub_stem_id: 5, ten_major_star_id: 7 },
  { id: 88, main_stem_id: 9, sub_stem_id: 6, ten_major_star_id: 8 },
  { id: 89, main_stem_id: 9, sub_stem_id: 7, ten_major_star_id: 9 },
  { id: 90, main_stem_id: 9, sub_stem_id: 8, ten_major_star_id: 10 },
  { id: 91, main_stem_id: 10, sub_stem_id: 10, ten_major_star_id: 1 },
  { id: 92, main_stem_id: 10, sub_stem_id: 9, ten_major_star_id: 2 },
  { id: 93, main_stem_id: 10, sub_stem_id: 2, ten_major_star_id: 3 },
  { id: 94, main_stem_id: 10, sub_stem_id: 1, ten_major_star_id: 4 },
  { id: 95, main_stem_id: 10, sub_stem_id: 4, ten_major_star_id: 5 },
  { id: 96, main_stem_id: 10, sub_stem_id: 3, ten_major_star_id: 6 },
  { id: 97, main_stem_id: 10, sub_stem_id: 6, ten_major_star_id: 7 },
  { id: 98, main_stem_id: 10, sub_stem_id: 5, ten_major_star_id: 8 },
  { id: 99, main_stem_id: 10, sub_stem_id: 8, ten_major_star_id: 9 },
  { id: 100, main_stem_id: 10, sub_stem_id: 7, ten_major_star_id: 10 }
]

stem_ten_star_mappings.each do |stem_ten_star_mapping|
  next if StemTenStarMapping.exists?(id: stem_ten_star_mapping[:id])
  StemTenStarMapping.create!(stem_ten_star_mapping)
end

stem_twelve_star_mappings = [
  { id: 1, stem_id: 1, branch_id: 10, twelve_sub_star_id: 1 },
  { id: 2, stem_id: 1, branch_id: 11, twelve_sub_star_id: 2 },
  { id: 3, stem_id: 1, branch_id: 12, twelve_sub_star_id: 3 },
  { id: 4, stem_id: 1, branch_id: 1, twelve_sub_star_id: 4 },
  { id: 5, stem_id: 1, branch_id: 2, twelve_sub_star_id: 5 },
  { id: 6, stem_id: 1, branch_id: 3, twelve_sub_star_id: 6 },
  { id: 7, stem_id: 1, branch_id: 4, twelve_sub_star_id: 7 },
  { id: 8, stem_id: 1, branch_id: 5, twelve_sub_star_id: 8 },
  { id: 9, stem_id: 1, branch_id: 6, twelve_sub_star_id: 9 },
  { id: 10, stem_id: 1, branch_id: 7, twelve_sub_star_id: 10 },
  { id: 11, stem_id: 1, branch_id: 8, twelve_sub_star_id: 11 },
  { id: 12, stem_id: 1, branch_id: 9, twelve_sub_star_id: 12 },
  { id: 13, stem_id: 2, branch_id: 9, twelve_sub_star_id: 1 },
  { id: 14, stem_id: 2, branch_id: 8, twelve_sub_star_id: 2 },
  { id: 15, stem_id: 2, branch_id: 7, twelve_sub_star_id: 3 },
  { id: 16, stem_id: 2, branch_id: 6, twelve_sub_star_id: 4 },
  { id: 17, stem_id: 2, branch_id: 5, twelve_sub_star_id: 5 },
  { id: 18, stem_id: 2, branch_id: 4, twelve_sub_star_id: 6 },
  { id: 19, stem_id: 2, branch_id: 3, twelve_sub_star_id: 7 },
  { id: 20, stem_id: 2, branch_id: 2, twelve_sub_star_id: 8 },
  { id: 21, stem_id: 2, branch_id: 1, twelve_sub_star_id: 9 },
  { id: 22, stem_id: 2, branch_id: 12, twelve_sub_star_id: 10 },
  { id: 23, stem_id: 2, branch_id: 11, twelve_sub_star_id: 11 },
  { id: 24, stem_id: 2, branch_id: 10, twelve_sub_star_id: 12 },
  { id: 25, stem_id: 3, branch_id: 1, twelve_sub_star_id: 1 },
  { id: 26, stem_id: 3, branch_id: 2, twelve_sub_star_id: 2 },
  { id: 27, stem_id: 3, branch_id: 3, twelve_sub_star_id: 3 },
  { id: 28, stem_id: 3, branch_id: 4, twelve_sub_star_id: 4 },
  { id: 29, stem_id: 3, branch_id: 5, twelve_sub_star_id: 5 },
  { id: 30, stem_id: 3, branch_id: 6, twelve_sub_star_id: 6 },
  { id: 31, stem_id: 3, branch_id: 7, twelve_sub_star_id: 7 },
  { id: 32, stem_id: 3, branch_id: 8, twelve_sub_star_id: 8 },
  { id: 33, stem_id: 3, branch_id: 9, twelve_sub_star_id: 9 },
  { id: 34, stem_id: 3, branch_id: 10, twelve_sub_star_id: 10 },
  { id: 35, stem_id: 3, branch_id: 11, twelve_sub_star_id: 11 },
  { id: 36, stem_id: 3, branch_id: 12, twelve_sub_star_id: 12 },
  { id: 37, stem_id: 4, branch_id: 12, twelve_sub_star_id: 1 },
  { id: 38, stem_id: 4, branch_id: 11, twelve_sub_star_id: 2 },
  { id: 39, stem_id: 4, branch_id: 10, twelve_sub_star_id: 3 },
  { id: 40, stem_id: 4, branch_id: 9, twelve_sub_star_id: 4 },
  { id: 41, stem_id: 4, branch_id: 8, twelve_sub_star_id: 5 },
  { id: 42, stem_id: 4, branch_id: 7, twelve_sub_star_id: 6 },
  { id: 43, stem_id: 4, branch_id: 6, twelve_sub_star_id: 7 },
  { id: 44, stem_id: 4, branch_id: 5, twelve_sub_star_id: 8 },
  { id: 45, stem_id: 4, branch_id: 4, twelve_sub_star_id: 9 },
  { id: 46, stem_id: 4, branch_id: 3, twelve_sub_star_id: 10 },
  { id: 47, stem_id: 4, branch_id: 2, twelve_sub_star_id: 11 },
  { id: 48, stem_id: 4, branch_id: 1, twelve_sub_star_id: 12 },
  { id: 49, stem_id: 5, branch_id: 1, twelve_sub_star_id: 1 },
  { id: 50, stem_id: 5, branch_id: 2, twelve_sub_star_id: 2 },
  { id: 51, stem_id: 5, branch_id: 3, twelve_sub_star_id: 3 },
  { id: 52, stem_id: 5, branch_id: 4, twelve_sub_star_id: 4 },
  { id: 53, stem_id: 5, branch_id: 5, twelve_sub_star_id: 5 },
  { id: 54, stem_id: 5, branch_id: 6, twelve_sub_star_id: 6 },
  { id: 55, stem_id: 5, branch_id: 7, twelve_sub_star_id: 7 },
  { id: 56, stem_id: 5, branch_id: 8, twelve_sub_star_id: 8 },
  { id: 57, stem_id: 5, branch_id: 9, twelve_sub_star_id: 9 },
  { id: 58, stem_id: 5, branch_id: 10, twelve_sub_star_id: 10 },
  { id: 59, stem_id: 5, branch_id: 11, twelve_sub_star_id: 11 },
  { id: 60, stem_id: 5, branch_id: 12, twelve_sub_star_id: 12 },
  { id: 61, stem_id: 6, branch_id: 12, twelve_sub_star_id: 1 },
  { id: 62, stem_id: 6, branch_id: 11, twelve_sub_star_id: 2 },
  { id: 63, stem_id: 6, branch_id: 10, twelve_sub_star_id: 3 },
  { id: 64, stem_id: 6, branch_id: 9, twelve_sub_star_id: 4 },
  { id: 65, stem_id: 6, branch_id: 8, twelve_sub_star_id: 5 },
  { id: 66, stem_id: 6, branch_id: 7, twelve_sub_star_id: 6 },
  { id: 67, stem_id: 6, branch_id: 6, twelve_sub_star_id: 7 },
  { id: 68, stem_id: 6, branch_id: 5, twelve_sub_star_id: 8 },
  { id: 69, stem_id: 6, branch_id: 4, twelve_sub_star_id: 9 },
  { id: 70, stem_id: 6, branch_id: 3, twelve_sub_star_id: 10 },
  { id: 71, stem_id: 6, branch_id: 2, twelve_sub_star_id: 11 },
  { id: 72, stem_id: 6, branch_id: 1, twelve_sub_star_id: 12 },
  { id: 73, stem_id: 7, branch_id: 4, twelve_sub_star_id: 1 },
  { id: 74, stem_id: 7, branch_id: 5, twelve_sub_star_id: 2 },
  { id: 75, stem_id: 7, branch_id: 6, twelve_sub_star_id: 3 },
  { id: 76, stem_id: 7, branch_id: 7, twelve_sub_star_id: 4 },
  { id: 77, stem_id: 7, branch_id: 8, twelve_sub_star_id: 5 },
  { id: 78, stem_id: 7, branch_id: 9, twelve_sub_star_id: 6 },
  { id: 79, stem_id: 7, branch_id: 10, twelve_sub_star_id: 7 },
  { id: 80, stem_id: 7, branch_id: 11, twelve_sub_star_id: 8 },
  { id: 81, stem_id: 7, branch_id: 12, twelve_sub_star_id: 9 },
  { id: 82, stem_id: 7, branch_id: 1, twelve_sub_star_id: 10 },
  { id: 83, stem_id: 7, branch_id: 2, twelve_sub_star_id: 11 },
  { id: 84, stem_id: 7, branch_id: 3, twelve_sub_star_id: 12 },
  { id: 85, stem_id: 8, branch_id: 3, twelve_sub_star_id: 1 },
  { id: 86, stem_id: 8, branch_id: 2, twelve_sub_star_id: 2 },
  { id: 87, stem_id: 8, branch_id: 1, twelve_sub_star_id: 3 },
  { id: 88, stem_id: 8, branch_id: 12, twelve_sub_star_id: 4 },
  { id: 89, stem_id: 8, branch_id: 11, twelve_sub_star_id: 5 },
  { id: 90, stem_id: 8, branch_id: 10, twelve_sub_star_id: 6 },
  { id: 91, stem_id: 8, branch_id: 9, twelve_sub_star_id: 7 },
  { id: 92, stem_id: 8, branch_id: 8, twelve_sub_star_id: 8 },
  { id: 93, stem_id: 8, branch_id: 7, twelve_sub_star_id: 9 },
  { id: 94, stem_id: 8, branch_id: 6, twelve_sub_star_id: 10 },
  { id: 95, stem_id: 8, branch_id: 5, twelve_sub_star_id: 11 },
  { id: 96, stem_id: 8, branch_id: 4, twelve_sub_star_id: 12 },
  { id: 97, stem_id: 9, branch_id: 7, twelve_sub_star_id: 1 },
  { id: 98, stem_id: 9, branch_id: 8, twelve_sub_star_id: 2 },
  { id: 99, stem_id: 9, branch_id: 9, twelve_sub_star_id: 3 },
  { id: 100, stem_id: 9, branch_id: 10, twelve_sub_star_id: 4 },
  { id: 101, stem_id: 9, branch_id: 11, twelve_sub_star_id: 5 },
  { id: 102, stem_id: 9, branch_id: 12, twelve_sub_star_id: 6 },
  { id: 103, stem_id: 9, branch_id: 1, twelve_sub_star_id: 7 },
  { id: 104, stem_id: 9, branch_id: 2, twelve_sub_star_id: 8 },
  { id: 105, stem_id: 9, branch_id: 3, twelve_sub_star_id: 9 },
  { id: 106, stem_id: 9, branch_id: 4, twelve_sub_star_id: 10 },
  { id: 107, stem_id: 9, branch_id: 5, twelve_sub_star_id: 11 },
  { id: 108, stem_id: 9, branch_id: 6, twelve_sub_star_id: 12 },
  { id: 109, stem_id: 10, branch_id: 6, twelve_sub_star_id: 1 },
  { id: 110, stem_id: 10, branch_id: 5, twelve_sub_star_id: 2 },
  { id: 111, stem_id: 10, branch_id: 4, twelve_sub_star_id: 3 },
  { id: 112, stem_id: 10, branch_id: 3, twelve_sub_star_id: 4 },
  { id: 113, stem_id: 10, branch_id: 2, twelve_sub_star_id: 5 },
  { id: 114, stem_id: 10, branch_id: 1, twelve_sub_star_id: 6 },
  { id: 115, stem_id: 10, branch_id: 12, twelve_sub_star_id: 7 },
  { id: 116, stem_id: 10, branch_id: 11, twelve_sub_star_id: 8 },
  { id: 117, stem_id: 10, branch_id: 10, twelve_sub_star_id: 9 },
  { id: 118, stem_id: 10, branch_id: 9, twelve_sub_star_id: 10 },
  { id: 119, stem_id: 10, branch_id: 8, twelve_sub_star_id: 11 },
  { id: 120, stem_id: 10, branch_id: 7, twelve_sub_star_id: 12 }
]

stem_twelve_star_mappings.each do |stem_twelve_star_mapping|
  next if StemTwelveStarMapping.exists?(id: stem_twelve_star_mapping[:id])
  StemTwelveStarMapping.create!(stem_twelve_star_mapping)
end

require 'date'

unless FortuneAnalysis.exists?
  start_date = Date.new(1925, 1, 1)
  end_date = Date.new(2044, 12, 31)

  (start_date..end_date).each do |date|
    FortuneAnalysisCalculator.call(date)
  end
end

# 職業（Job）マスタデータ
jobs = [
  { id: 1, name: '会社員' },
  { id: 2, name: '経営者・役員' },
  { id: 3, name: '自営業' },
  { id: 4, name: '公務員' },
  { id: 5, name: '医師' },
  { id: 6, name: '弁護士' },
  { id: 7, name: '教師' },
  { id: 8, name: '看護師' },
  { id: 9, name: '主婦・主夫' },
  { id: 10, name: '学生' },
  { id: 11, name: 'アルバイト・パート' },
  { id: 12, name: 'フリーランス' },
  { id: 13, name: '退職者' },
  { id: 14, name: '無職' },
  { id: 15, name: 'その他' }
]

puts "職業（Job）データを登録しています..."
jobs.each do |job|
  # 同じIDで既に存在する場合はスキップ
  next if Job.exists?(id: job[:id])
  Job.create!(job)
end
puts "職業（Job）データの登録が完了しました"

# 職種（Occupation）マスタデータ
occupations = [
  { id: 1, name: '農林水産業' },
  { id: 2, name: '建設業' },
  { id: 3, name: '製造業' },
  { id: 4, name: '電気・ガス・水道業' },
  { id: 5, name: '情報通信業' },
  { id: 6, name: '運輸業' },
  { id: 7, name: '卸売・小売業' },
  { id: 8, name: '金融・保険業' },
  { id: 9, name: '不動産業' },
  { id: 10, name: '飲食・宿泊業' },
  { id: 11, name: '医療・福祉' },
  { id: 12, name: '教育・学習支援' },
  { id: 13, name: 'サービス業' },
  { id: 14, name: '公務' },
  { id: 15, name: '芸能・エンターテイメント' },
  { id: 16, name: 'スポーツ' },
  { id: 17, name: 'その他' }
]

puts "職種（Occupation）データを登録しています..."
occupations.each do |occupation|
  # 同じIDで既に存在する場合はスキップ
  next if Occupation.exists?(id: occupation[:id])
  Occupation.create!(occupation)
end
puts "職種（Occupation）データの登録が完了しました"
