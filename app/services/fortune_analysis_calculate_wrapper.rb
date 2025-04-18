class FortuneAnalysisCalculateWrapper
  attr_reader :result,
              :date,
              :gender,
              :day_stem,
              :month_stem,
              :year_stem,
              :day_branch,
              :month_branch,
              :year_branch,
              :day_qi_stem,
              :month_qi_stem,
              :year_qi_stem,
              :day_heavenly_void

  def initialize(calculate_params)
    @result = calculate_params[:result]
    @date = calculate_params[:date]
    @gender = calculate_params[:gender]
    @day_stem = calculate_params[:day_stem]
    @month_stem = calculate_params[:month_stem]
    @year_stem = calculate_params[:year_stem]
    @day_branch = calculate_params[:day_branch]
    @month_branch = calculate_params[:month_branch]
    @year_branch = calculate_params[:year_branch]
    @day_qi_stem = calculate_params[:day_qi_stem]
    @month_qi_stem = calculate_params[:month_qi_stem]
    @year_qi_stem = calculate_params[:year_qi_stem]
    @day_heavenly_void = calculate_params[:day_heavenly_void]
  end

  # 六親法
  def stem_lineage
    StemLineageCalculator.call(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, year_qi_stem, day_qi_stem, gender)
  end

  # 数理法
  def numerological_calculator
    NumerologicalCalculator.call(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch)
  end

  # 位相法
  def phase_method
    PhaseMethodCalculator.call(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, result)
  end

  # 年運
  def yearly_fortune
    YearlyFortuneCalculator.call(date, day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, day_heavenly_void)
  end
end
