class FortuneAnalysisController < ApplicationController
  def index
    @date = Date.today
  end

  def calculate
    @date = Date.parse(params[:date])
    @result = FortuneAnalysis.preload(
      sexagenary_cycle_year: { stem: {}, branch: { first_stem: {}, second_stem: {}, third_stem: {} } },
      sexagenary_cycle_month: { stem: {}, branch: { first_stem: {}, second_stem: {}, third_stem: {} } },
      sexagenary_cycle_day: { stem: {}, branch: { first_stem: {}, second_stem: {}, third_stem: {} } }
    ).find_by(birthday: @date)

    @year_heavenly_void = @result.sexagenary_cycle_year.heavenly_void
    @day_heavenly_void = @result.sexagenary_cycle_day.heavenly_void

    @day_stem = @result.sexagenary_cycle_day.stem
    @month_stem = @result.sexagenary_cycle_month.stem
    @year_stem = @result.sexagenary_cycle_year.stem

    @day_branch = @result.sexagenary_cycle_day.branch
    @month_branch = @result.sexagenary_cycle_month.branch
    @year_branch = @result.sexagenary_cycle_year.branch

    @year_qi_stem, @month_qi_stem, @day_qi_stem = birth_qi

    @ten_stars, @twelve_stars = calculate_yang_chart

    @youth_sub_star, @middle_age_sub_star, @old_age_sub_star = calculate_branch_and_stem_sub_star

    @abnormals = abnormals

    @birth_voids = birth_voids

    render :index
  end

  private

  def birth_qi
    days = qi_days
    year_qi_stem = calculate_qi(days, @year_branch)
    month_qi_stem = calculate_qi(days, @month_branch)
    day_qi_stem = calculate_qi(days, @day_branch)

    return year_qi_stem, month_qi_stem, day_qi_stem
  end

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
    day = @date.day
    entry_day = LunarCalendarEntry.lunar_birth_day(@date)
    if day >= entry_day
      day - entry_day
    else
      LunarCalendarEntry.lunar_birth_last_day_previous_month(@date) - LunarCalendarEntry.lunar_birth_day_previous_month(@date) + day
    end
  end

  def calculate_yang_chart
    stems = {
      east: @year_qi_stem,
      south: @month_stem,
      west: @day_qi_stem,
      north: @year_stem,
      center: @month_qi_stem
    }

    # 十大主星の取得
    ten_stars = stems.transform_values do |sub_stem|
      StemTenStarMapping.find_by!(main_stem: @day_stem, sub_stem: sub_stem).ten_major_star
    end

    # 十二大従星の取得
    branches = {
      first: @day_branch,
      second: @month_branch,
      third: @year_branch
    }

    twelve_stars = branches.transform_values do |branch|
      StemTwelveStarMapping.find_by!(stem: @day_stem, branch: branch).twelve_sub_star
    end

    return ten_stars, twelve_stars
  end

  def calculate_branch_and_stem_sub_star
    youth_sub_star = StemTwelveStarMapping.find_by!(stem: @day_stem, branch: @year_branch).twelve_sub_star
    middle_age_sub_star = StemTwelveStarMapping.find_by!(stem: @day_stem, branch: @month_branch).twelve_sub_star
    old_age_sub_star = StemTwelveStarMapping.find_by!(stem: @day_stem, branch: @day_branch).twelve_sub_star

    return youth_sub_star, middle_age_sub_star, old_age_sub_star
  end

  # 異常干支を配列で取得
  def abnormals
    [
      @result.sexagenary_cycle_day.abnormal_stem_and_branch_name,
      @result.sexagenary_cycle_month.abnormal_stem_and_branch_name,
      @result.sexagenary_cycle_year.abnormal_stem_and_branch_name
    ].compact
  end

  # 生日中殺などをオブジェクトで持つ
  def birth_voids
    {
      birth_day_void: birth_day_void? ? '生日中殺' : nil,
      birth_month_void: birth_month_void? ? '生月中殺' : nil,
      birth_year_void: birth_year_void? ? '生年中殺' : nil,
      compatible_void: compatible_void? ? '互換中殺' : nil,
      day_position_void: @result.sexagenary_cycle_day.day_position_void? ? '日座天中殺' : nil,
      day_residence_void: @result.sexagenary_cycle_day.day_residence_void? ? '日居天中殺' : nil,
      double_birth_void: double_birth_void? ? '宿命二中殺' : nil,
      complete_void: complete_void? ? '全天中殺' : nil
    }
  end

  def birth_day_void?
    @year_heavenly_void.chars.include?(@day_branch.name)
  end

  def birth_month_void?
    @day_heavenly_void.chars.include?(@month_branch.name)
  end

  def birth_year_void?
    @day_heavenly_void.chars.include?(@year_branch.name)
  end

  def compatible_void?
    birth_day_void? && birth_year_void?
  end

  def double_birth_void?
    birth_month_void? && birth_year_void?
  end

  def complete_void?
    @result.sexagenary_cycle_day.day_position_void? && birth_month_void? && birth_year_void?
  end
end
