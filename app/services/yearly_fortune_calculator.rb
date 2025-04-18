class YearlyFortuneCalculator
  attr_reader :day_stem,
              :month_stem,
              :year_stem,
              :day_branch,
              :month_branch,
              :year_branch,
              :day_heavenly_void,
              :branch_relationships,
              :yearly_data,
              :date

  def initialize(date, day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, day_heavenly_void)
    @date = date
    @day_stem = day_stem
    @month_stem = month_stem
    @year_stem = year_stem
    @day_branch = day_branch
    @month_branch = month_branch
    @year_branch = year_branch
    @day_heavenly_void = day_heavenly_void.gsub('天中殺', '')
    @branch_relationships = Branch::RELATIONSHIPS_HASH
    @yearly_data = CalendarDetail.yearly_stem_and_branch
  end

  def self.call(date, day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, day_heavenly_void)
    new(date, day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, day_heavenly_void).calculate
  end

  def calculate
    build_yearly_fortune
  end

  private

  # [
  #   {
  #     year_and_age: '2025(1歳)',
  #     stem_and_branch: '甲子',
  #     major_star: '調舒星',
  #     sub_star: '天馳星',
  #     relationship: {
  #       day: '支合',
  #       month: nil,
  #       year: '半会'
  #     }
  #   }
  # ]
  # 干合, 大半会, 天剋地冲, 律音, 納音
  def build_yearly_fortune
    first_year = date.year
    # first_yearから100年先までのデータを取得
    # yearly_dataは1924年から2100年までのデータを持っている
    # first_yearから始めたいので、それ以前の年を除外する
    init_yearly_data = yearly_data.select { |year_data| year_data[:year] >= first_year && year_data[:year] <= first_year + 100 }
    init_yearly_data.map do |year_data|
      year = year_data[:year]
      yearly_branch_name = year_data[:branch]
      yearly_stem_name = year_data[:stem]
      age = year - first_year
      stem_and_branch = year_data[:stem_and_branch]
      major_star = MajorStarMapping.find_by(main_stem: day_stem.name, sub_stem: year_data[:stem]).ten_major_star
      sub_star = SubStarMapping.find_by(stem: day_stem.name, branch: yearly_branch_name).twelve_sub_star
      relationship = {
        day: build_relationship(day_stem.name, day_branch.name, yearly_stem_name, yearly_branch_name),
        month: build_relationship(month_stem.name, month_branch.name, yearly_stem_name, yearly_branch_name),
        year: build_relationship(year_stem.name, year_branch.name, yearly_stem_name, yearly_branch_name)
      }
      heavenly_void = build_heavenly_void(yearly_branch_name)

      {
        year_and_age: "#{year}(#{age}歳)",
        stem_and_branch: stem_and_branch,
        major_star: major_star,
        sub_star: sub_star,
        relationship: relationship,
        heavenly_void: heavenly_void
      }
    end
  end

  def build_relationship(stem, branch, yearly_stem_name, yearly_branch_name)
    strong_half_trine = nil
    nacchin = nil
    dual_clash = nil

    # 位相
    relationship = branch_relationships[branch.to_sym][yearly_branch_name.to_sym]
    # 干合
    union = Stem::UNION_NAMES.include?(stem + yearly_stem_name) ? '干合' : nil
    # 律音
    ricchin = stem == yearly_stem_name && branch == yearly_branch_name ? '律音' : nil

    if relationship.present?
      # 大半会
      if relationship == '半会' && stem == yearly_stem_name
        strong_half_trine = '大半会'
        relationship = relationship.gsub('半会', '')
      end

      
      if relationship.include?('冲')
        # 納音
        nacchin = relationship.include?('冲') && stem == yearly_stem_name ? '納音' : nil

        if nacchin.nil?
          # 天剋地冲（干の陰陽が同じ、かつ相剋の関係）
          yin_yang = StemDefinition.find_by(name: stem).yin_yang
          year_stem_yin_yang = StemDefinition.find_by(name: yearly_stem_name).yin_yang
          dual_clash = Stem::STEM_CONFLICTS.include?(stem + yearly_stem_name) && yin_yang == year_stem_yin_yang ? '天剋地冲' : nil
        end

        if nacchin.present? || dual_clash.present?
          relationship = relationship.gsub('冲', '')
        end
      end
    end

    # nilの文字列の変数以外を\nで連結
    [relationship, union, strong_half_trine, ricchin, nacchin, dual_clash].compact.join("\n")
  end

  def build_heavenly_void(yearly_branch_name)
    day_heavenly_void.include?(yearly_branch_name) ? '⚪︎' : nil
  end
end
