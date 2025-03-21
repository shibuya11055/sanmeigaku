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

    @ten_stars_relations = ten_stars_relations

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

    # 方角ごとの意味
    ten_star_direction = TenStarDirection.new
    ten_stars[:east_message] = ten_star_direction.get_message("east.#{ten_stars[:east].name}")
    ten_stars[:south_message] = ten_star_direction.get_message("south.#{ten_stars[:south].name}")
    ten_stars[:west_message] = ten_star_direction.get_message("west.#{ten_stars[:west].name}")
    ten_stars[:north_message] = ten_star_direction.get_message("north.#{ten_stars[:north].name}")
    ten_stars[:center_message] = ten_star_direction.get_message("center.#{ten_stars[:center].name}")

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

  def ten_stars_relations
    center_id = @ten_stars[:center].element_id
    synergy = TenStarSynergy.new

    top_relation = ElementRelation.find_relation(center_id, @ten_stars[:north].element_id)
    right_relation = ElementRelation.find_relation(center_id, @ten_stars[:east].element_id)
    bottom_relation = ElementRelation.find_relation(center_id, @ten_stars[:south].element_id)
    left_relation = ElementRelation.find_relation(center_id, @ten_stars[:west].element_id)

    top_state = top_relation.state
    right_state = right_relation.state
    bottom_state = bottom_relation.state
    left_state = left_relation.state

    {
      top: ElementRelation.top_icon(top_state),
      right: ElementRelation.right_icon(right_state),
      bottom: ElementRelation.bottom_icon(bottom_state),
      left: ElementRelation.left_icon(left_state),
      top_message: synergy.get_message("north.#{top_state}"),
      right_message: synergy.get_message("east.#{right_state}"),
      bottom_message: synergy.get_message("south.#{bottom_state}"),
      left_message: synergy.get_message("west.#{left_state}")
    }
  end
end
