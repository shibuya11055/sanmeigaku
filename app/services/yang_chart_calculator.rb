class YangChartCalculator
  attr_reader :day_qi_stem, :month_qi_stem, :year_qi_stem,
  :day_stem, :month_stem, :year_stem,
  :day_branch, :month_branch, :year_branch

  def initialize(day_qi_stem, month_qi_stem, year_qi_stem, day_stem, month_stem, year_stem, day_branch, month_branch, year_branch)
    @day_qi_stem = day_qi_stem
    @month_qi_stem = month_qi_stem
    @year_qi_stem = year_qi_stem
    @day_stem = day_stem
    @month_stem = month_stem
    @year_stem = year_stem
    @day_branch = day_branch
    @month_branch = month_branch
    @year_branch = year_branch
  end

  def self.call(day_qi_stem, month_qi_stem, year_qi_stem, day_stem, month_stem, year_stem, day_branch, month_branch, year_branch)
    new(day_qi_stem, month_qi_stem, year_qi_stem, day_stem, month_stem, year_stem, day_branch, month_branch, year_branch).calculate
  end

  def calculate
    stems = {
      east: year_qi_stem,
      south: month_stem,
      west: day_qi_stem,
      north: year_stem,
      center: month_qi_stem
    }

    # 十大主星の取得
    ten_stars = stems.transform_values do |sub_stem|
      StemTenStarMapping.find_by!(main_stem: day_stem, sub_stem: sub_stem).ten_major_star
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
      first: day_branch,
      second: month_branch,
      third: year_branch
    }

    twelve_stars = branches.transform_values do |branch|
      StemTwelveStarMapping.find_by!(stem: day_stem, branch: branch).twelve_sub_star
    end

    return ten_stars, twelve_stars
  end
end
