class PhaseMethodCalculator
  attr_reader :day_stem,
              :month_stem,
              :year_stem,
              :day_branch,
              :month_branch,
              :year_branch

  def initialize(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch)
    @day_stem = day_stem
    @month_stem = month_stem
    @year_stem = year_stem
    @day_branch = day_branch
    @month_branch = month_branch
    @year_branch = year_branch
  end

  def self.call(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch)
    new(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch).calculate
  end

  def calculate
  end

  def water_trine
  end
end
