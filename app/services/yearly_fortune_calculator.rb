class YearlyFortuneCalculator
  attr_reader :day_stem,
              :month_stem,
              :year_stem,
              :day_branch,
              :month_branch,
              :year_branch,
              :day_heavenly_void,
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
        day: RelationshipCalculator.call(day_stem.name, day_branch.name, yearly_stem_name, yearly_branch_name),
        month: RelationshipCalculator.call(month_stem.name, month_branch.name, yearly_stem_name, yearly_branch_name),
        year: RelationshipCalculator.call(year_stem.name, year_branch.name, yearly_stem_name, yearly_branch_name)
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

  def build_heavenly_void(yearly_branch_name)
    day_heavenly_void.include?(yearly_branch_name) ? '⚪︎' : nil
  end
end
