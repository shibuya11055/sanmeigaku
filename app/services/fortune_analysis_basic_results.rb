class FortuneAnalysisBasicResults
  include ActiveModel::Model

  attr_reader :day_stem, :month_stem, :year_stem,
              :day_branch, :month_branch, :year_branch,
              :day_heavenly_void, :year_heavenly_void, :date,
              :fortune_analysis

  def initialize(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, year_heavenly_void, day_heavenly_void, date, fortune_analysis)
    @day_stem = day_stem
    @month_stem = month_stem
    @year_stem = year_stem
    @day_branch = day_branch
    @month_branch = month_branch
    @year_branch = year_branch
    @year_heavenly_void = year_heavenly_void
    @day_heavenly_void = day_heavenly_void
    @date = date
    @fortune_analysis = fortune_analysis
  end

  # 蔵干
  def birth_qi
    days = qi_days
    year_qi_stem = calculate_qi(days, year_branch)
    month_qi_stem = calculate_qi(days, month_branch)
    day_qi_stem = calculate_qi(days, day_branch)

    return year_qi_stem, month_qi_stem, day_qi_stem
  end


  # 十二大従星
  def branch_and_stem_sub_star
    youth_sub_star = StemTwelveStarMapping.find_by!(stem: day_stem, branch: year_branch).twelve_sub_star
    middle_age_sub_star = StemTwelveStarMapping.find_by!(stem: day_stem, branch: month_branch).twelve_sub_star
    old_age_sub_star = StemTwelveStarMapping.find_by!(stem: day_stem, branch: day_branch).twelve_sub_star

    return youth_sub_star, middle_age_sub_star, old_age_sub_star
  end

  # 異常干支
  def abnormals
    [
      fortune_analysis.sexagenary_cycle_day.abnormal_stem_and_branch_name,
      fortune_analysis.sexagenary_cycle_month.abnormal_stem_and_branch_name,
      fortune_analysis.sexagenary_cycle_year.abnormal_stem_and_branch_name
    ].compact
  end

  # 生日中殺などをオブジェクトで持つ
  def birth_voids
    {
      birth_day_void: birth_day_void? ? '生日中殺' : nil,
      birth_month_void: birth_month_void? ? '生月中殺' : nil,
      birth_year_void: birth_year_void? ? '生年中殺' : nil,
      compatible_void: compatible_void? ? '互換中殺' : nil,
      day_position_void: fortune_analysis.sexagenary_cycle_day.day_position_void? ? '日座天中殺' : nil,
      day_residence_void: fortune_analysis.sexagenary_cycle_day.day_residence_void? ? '日居天中殺' : nil,
      double_birth_void: double_birth_void? ? '宿命二中殺' : nil,
      complete_void: complete_void? ? '全天中殺' : nil
    }
  end

  # 干合
  def stem_unions
    stem = Stem.new
    day_and_month_ids = stem.union_ids(day_stem.id, month_stem.id)
    day_and_year_ids = stem.union_ids(day_stem.id, year_stem.id)
    month_and_year_ids = stem.union_ids(month_stem.id, year_stem.id)

    day_and_month_union_names = day_and_month_ids.present? ? Stem.find(day_and_month_ids).map(&:name) : nil
    day_and_year_union_names = day_and_year_ids.present? ? Stem.find(day_and_year_ids).map(&:name) : nil
    month_and_year_union_names = month_and_year_ids.present? ? Stem.find(month_and_year_ids).map(&:name) : nil

    {
      day_and_month: {
          title: '日干・月干',
        before: [day_stem.name, month_stem.name],
        result: day_and_month_union_names
      },
      day_and_year: {
        title: '日干・年干',
        before: [day_stem.name, year_stem.name],
        result: day_and_year_union_names
      },
      month_and_year: {
        title: '月干・年干',
        before: [month_stem.name, year_stem.name],
        result: month_and_year_union_names
      }
    }
  end

  private

  def calculate_qi(days, branch)
    if branch.first_stem.present? && branch.first_stem_period_day >= days
      branch.first_stem
    elsif branch.second_stem.present? && branch.second_stem_period_day >= days
      branch.second_stem
    else
      branch.third_stem
    end
  end

  def qi_days
    day = date.day
    entry_day = LunarCalendarEntry.lunar_birth_day(date)
    if day >= entry_day
      day - entry_day
    else
      LunarCalendarEntry.lunar_birth_last_day_previous_month(date) - LunarCalendarEntry.lunar_birth_day_previous_month(date) + day
    end
  end

  def birth_day_void?
    year_heavenly_void.chars.include?(day_branch.name)
  end

  def birth_month_void?
    day_heavenly_void.chars.include?(month_branch.name)
  end

  def birth_year_void?
    day_heavenly_void.chars.include?(year_branch.name)
  end

  def compatible_void?
    birth_day_void? && birth_year_void?
  end

  def double_birth_void?
    birth_month_void? && birth_year_void?
  end

  def complete_void?
    fortune_analysis.sexagenary_cycle_day.day_position_void? && birth_month_void? && birth_year_void?
  end
end
