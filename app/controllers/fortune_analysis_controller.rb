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

    @day_stem = @result.sexagenary_cycle_day.stem
    @month_stem = @result.sexagenary_cycle_month.stem
    @year_stem = @result.sexagenary_cycle_year.stem

    @day_branch = @result.sexagenary_cycle_day.branch
    @month_branch = @result.sexagenary_cycle_month.branch
    @year_branch = @result.sexagenary_cycle_year.branch

    @year_qi_stem, @month_qi_stem, @day_qi_stem = birth_qi

    @ten_stars, @twelve_stars = calculate_yang_chart

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
end
