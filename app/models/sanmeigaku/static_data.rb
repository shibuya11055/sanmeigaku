module Sanmeigaku
  module StaticData
    Element = Data.define(:id, :name, :description)

    Stem = Data.define(:id, :name, :yin_yang, :element_id) do
      def element
        StaticData.element(element_id)
      end

      def image_name
        {
          '甲' => '木陽.png', '乙' => '木陰.png', '丙' => '火陽.png', '丁' => '火陰.png',
          '戊' => '土陽.png', '己' => '土陰.png', '庚' => '金陽.png', '辛' => '金陰.png',
          '壬' => '水陽.png', '癸' => '水陰.png'
        }.fetch(name, 'default.png')
      end

      def yin_yang_convert
        StaticData.stem(id.even? ? id - 1 : id + 1)
      end

      def union_stem
        StaticData.stem(StaticData::UNION_PARTNERS[id])
      end

      def generates_stem
        target_element_id = element_id == 5 ? 1 : element_id + 1
        target_yin_yang = yin_yang == '陽' ? '陰' : '陽'
        StaticData.stems.find { |stem| stem.element_id == target_element_id && stem.yin_yang == target_yin_yang }
      end

      def generated_by_stem
        target_element_id = element_id == 1 ? 5 : element_id - 1
        target_yin_yang = yin_yang == '陽' ? '陰' : '陽'
        StaticData.stems.find { |stem| stem.element_id == target_element_id && stem.yin_yang == target_yin_yang }
      end
    end

    Branch = Data.define(
      :id,
      :name,
      :yin_yang,
      :element_id,
      :first_stem_id,
      :first_stem_period_day,
      :second_stem_id,
      :second_stem_period_day,
      :third_stem_id
    ) do
      def element
        StaticData.element(element_id)
      end

      def first_stem
        first_stem_id && StaticData.stem(first_stem_id)
      end

      def second_stem
        second_stem_id && StaticData.stem(second_stem_id)
      end

      def third_stem
        third_stem_id && StaticData.stem(third_stem_id)
      end

      def stem_ids
        [first_stem_id, second_stem_id, third_stem_id].compact
      end

      def image_name
        {
          '子' => '水陰.png', '丑' => '土陰.png', '寅' => '木陽.png', '卯' => '木陰.png',
          '辰' => '土陽.png', '巳' => '火陽.png', '午' => '火陽.png', '未' => '土陰.png',
          '申' => '金陽.png', '酉' => '金陰.png', '戌' => '土陽.png', '亥' => '水陽.png'
        }.fetch(name, 'default.png')
      end
    end

    Cycle = Data.define(:id, :name, :stem_id, :branch_id, :heavenly_void) do
      def stem
        StaticData.stem(stem_id)
      end

      def branch
        StaticData.branch(branch_id)
      end

      def stem_and_branch
        "#{stem.name}#{branch.name}"
      end

      def abnormal?
        StaticData::ABNORMAL_CYCLE_IDS.include?(id)
      end

      def abnormal_stem_and_branch_name
        abnormal? ? stem_and_branch : nil
      end

      def day_position_void?
        [11, 12].include?(id)
      end

      def day_residence_void?
        [41, 42].include?(id)
      end
    end

    TenMajorStar = Data.define(:id, :name, :yin_yang, :element_id) do
      def element
        StaticData.element(element_id)
      end

      def image_name
        {
          '貫索星' => '木陽.png', '石門星' => '木陰.png', '鳳閣星' => '火陽.png', '調舒星' => '火陰.png',
          '禄存星' => '土陽.png', '司禄星' => '土陰.png', '車騎星' => '金陽.png', '牽牛星' => '金陰.png',
          '龍高星' => '水陽.png', '玉堂星' => '水陰.png'
        }.fetch(name, nil)
      end
    end

    SELF_IDS = [2, 4, 6, 8, 10].freeze
    OTHER_IDS = [1, 3, 5, 7, 9].freeze
    STRUCTURE_IDS = [8, 7, 10, 9, 2, 1, 4, 3, 6, 5].freeze

    TwelveSubStar = Data.define(:id, :name, :energy)

    Lineage = Data.define(
      :id,
      :day_stem_id,
      :m_stem_id,
      :f_stem_id,
      :m_grandmother_stem_id,
      :m_grandfather_stem_id,
      :f_grandmother_stem_id,
      :f_grandfather_stem_id,
      :spouse_stem_id,
      :mother_in_law_stem_id,
      :father_in_law_stem_id,
      :male_child_stem_id,
      :female_child_stem_id,
      :male_child_spouse_stem_id,
      :female_child_spouse_stem_id
    ) do
      %i[
        day_stem m_stem f_stem m_grandmother_stem m_grandfather_stem f_grandmother_stem
        f_grandfather_stem spouse_stem mother_in_law_stem father_in_law_stem male_child_stem
        female_child_stem male_child_spouse_stem female_child_spouse_stem
      ].each do |role|
        define_method(role) { StaticData.stem(public_send("#{role}_id")) }
      end
    end

    Result = Data.define(
      :birthday,
      :sexagenary_cycle_year,
      :sexagenary_cycle_month,
      :sexagenary_cycle_day
    ) do
      def sexagenary_cycle_year_id
        sexagenary_cycle_year.id
      end

      def sexagenary_cycle_month_id
        sexagenary_cycle_month.id
      end

      def sexagenary_cycle_day_id
        sexagenary_cycle_day.id
      end
    end

    ELEMENTS = [
      Element.new(1, '木', '成長、生命力、柔軟性を象徴する。'),
      Element.new(2, '火', '情熱、エネルギー、変革を象徴する。'),
      Element.new(3, '土', '安定、基盤、育成を象徴する。'),
      Element.new(4, '金', '強さ、構造、規律を象徴する。'),
      Element.new(5, '水', '知恵、適応力、流れを象徴する。')
    ].freeze

    STEM_NAMES = '甲乙丙丁戊己庚辛壬癸'.chars.freeze
    STEMS = STEM_NAMES.each_with_index.map do |name, index|
      id = index + 1
      Stem.new(id, name, id.odd? ? '陽' : '陰', ((id - 1) / 2) + 1)
    end.freeze

    BRANCH_DATA = [
      [1, '子', 0, 5, nil, nil, nil, nil, 10],
      [2, '丑', 0, 3, 10, 9, 8, 12, 6],
      [3, '寅', 1, 1, 5, 7, 3, 14, 1],
      [4, '卯', 0, 1, nil, nil, nil, nil, 2],
      [5, '辰', 1, 3, 2, 9, 10, 12, 5],
      [6, '巳', 1, 2, 5, 5, 7, 14, 3],
      [7, '午', 0, 2, nil, nil, 6, 19, 4],
      [8, '未', 0, 3, 4, 9, 2, 12, 6],
      [9, '申', 1, 4, 5, 10, 9, 13, 7],
      [10, '酉', 0, 4, nil, nil, nil, nil, 8],
      [11, '戌', 1, 3, 8, 9, 4, 12, 5],
      [12, '亥', 1, 5, nil, nil, 1, 12, 9]
    ].freeze

    BRANCHES = BRANCH_DATA.map { |data| Branch.new(*data) }.freeze

    HEAVENLY_VOID_NAMES = %w[戌亥 申酉 午未 辰巳 寅卯 子丑].freeze
    CYCLES = (1..60).map do |id|
      stem_id = ((id - 1) % 10) + 1
      branch_id = ((id - 1) % 12) + 1
      Cycle.new(id, "#{STEM_NAMES[stem_id - 1]}#{BRANCHES[branch_id - 1].name}", stem_id, branch_id, HEAVENLY_VOID_NAMES[(id - 1) / 10])
    end.freeze

    TEN_MAJOR_STAR_NAMES = %w[貫索星 石門星 鳳閣星 調舒星 禄存星 司禄星 車騎星 牽牛星 龍高星 玉堂星].freeze
    TEN_MAJOR_STARS = TEN_MAJOR_STAR_NAMES.each_with_index.map do |name, index|
      id = index + 1
      TenMajorStar.new(id, name, id.even? ? '陰' : '陽', ((id - 1) / 2) + 1)
    end.freeze

    TWELVE_SUB_STARS = [
      [1, '天報星', 3], [2, '天印星', 6], [3, '天貴星', 9], [4, '天恍星', 7],
      [5, '天南星', 10], [6, '天禄星', 11], [7, '天将星', 12], [8, '天堂星', 8],
      [9, '天胡星', 4], [10, '天極星', 2], [11, '天庫星', 5], [12, '天馳星', 1]
    ].map { |data| TwelveSubStar.new(*data) }.freeze

    UNION_PARTNERS = {
      1 => 6, 6 => 1, 3 => 8, 8 => 3, 5 => 10, 10 => 5, 7 => 2, 2 => 7, 9 => 4, 4 => 9
    }.freeze

    ABNORMAL_CYCLE_IDS = [11, 12, 35, 37, 48, 54, 18, 19, 24, 23, 25, 30, 36].freeze

    LINEAGES = [
      [1, 10, 5, 7, 2, 4, 9, 6, 3, 8, 2, 4, 2, 9],
      [2, 9, 4, 8, 3, 1, 6, 7, 6, 1, 10, 3, 5, 8],
      [3, 2, 7, 9, 4, 6, 1, 8, 5, 10, 9, 6, 4, 1],
      [4, 1, 6, 10, 5, 3, 8, 9, 8, 3, 2, 5, 7, 10],
      [5, 4, 9, 1, 6, 8, 3, 10, 7, 2, 1, 8, 6, 3],
      [6, 3, 8, 2, 7, 5, 10, 1, 10, 5, 4, 7, 9, 2],
      [7, 6, 1, 3, 8, 10, 5, 2, 9, 4, 3, 10, 8, 5],
      [8, 5, 10, 4, 9, 7, 2, 3, 2, 7, 6, 9, 1, 4],
      [9, 8, 3, 5, 10, 2, 7, 4, 1, 6, 5, 2, 10, 7],
      [10, 7, 2, 6, 1, 9, 4, 5, 4, 9, 8, 1, 3, 6]
    ].map { |data| Lineage.new(data[0], *data) }.freeze

    ELEMENTS_BY_ID = ELEMENTS.index_by(&:id).freeze
    STEMS_BY_ID = STEMS.index_by(&:id).freeze
    BRANCHES_BY_ID = BRANCHES.index_by(&:id).freeze
    CYCLES_BY_ID = CYCLES.index_by(&:id).freeze
    TEN_MAJOR_STARS_BY_ID = TEN_MAJOR_STARS.index_by(&:id).freeze
    TWELVE_SUB_STARS_BY_ID = TWELVE_SUB_STARS.index_by(&:id).freeze
    LINEAGES_BY_DAY_STEM_ID = LINEAGES.index_by(&:day_stem_id).freeze

    class << self
      def element(id)
        ELEMENTS_BY_ID.fetch(id)
      end

      def stem(id)
        STEMS_BY_ID.fetch(id)
      end

      def stems
        STEMS
      end

      def stem_by_name(name)
        STEMS.find { |stem| stem.name == name }
      end

      def branch(id)
        BRANCHES_BY_ID.fetch(id)
      end

      def branches
        BRANCHES
      end

      def branch_by_name(name)
        BRANCHES.find { |branch| branch.name == name }
      end

      def cycle(id)
        CYCLES_BY_ID.fetch(id)
      end

      def ten_major_star(id)
        TEN_MAJOR_STARS_BY_ID.fetch(id)
      end

      def twelve_sub_star(id)
        TWELVE_SUB_STARS_BY_ID.fetch(id)
      end

      def ten_major_star_for(main_stem, sub_stem)
        mapping = MajorStarMapping.find_by(main_stem: main_stem.name, sub_stem: sub_stem.name)
        TEN_MAJOR_STARS.find { |star| star.name == mapping&.ten_major_star }
      end

      def twelve_sub_star_for(stem, branch)
        mapping = SubStarMapping.find_by(stem: stem.name, branch: branch.name)
        TWELVE_SUB_STARS.find { |star| star.name == mapping&.twelve_sub_star }
      end

      def energy(stem_id, branch_id)
        twelve_sub_star_for(stem(stem_id), branch(branch_id))&.energy
      end

      def union_ids(first_stem_id, second_stem_id)
        input_pair = [first_stem_id, second_stem_id].sort

        StemConst::STEM_UNIONS.each do |pair, result|
          return should_reverse_union?(result) ? result.reverse : result if pair == input_pair
          return should_reverse_union?(pair) ? pair.reverse : pair if result == input_pair
        end

        nil
      end

      def lineage_for(day_stem)
        LINEAGES_BY_DAY_STEM_ID.fetch(day_stem.id)
      end

      def yearly_stem_and_branch
        (1924..2200).map do |year|
          stem = STEMS[(year - 4) % 10]
          branch = BRANCHES[(year - 4) % 12]
          {
            year: year,
            stem: stem.name,
            branch: branch.name,
            stem_and_branch: "#{stem.name}#{branch.name}"
          }
        end
      end

      private

      def should_reverse_union?(union)
        union == [2, 7] || union == [4, 9]
      end
    end
  end
end
