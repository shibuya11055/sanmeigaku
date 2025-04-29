class FortuneAnalysisController < ApplicationController
  def index
    # パラメータから日付と性別を取得（なければデフォルト値を使用）
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    @gender = params[:gender] || 'male'

    # 日付パラメータがある場合は計算結果を表示
    if params[:date].present?
      @result = FortuneAnalysis.preload(
        sexagenary_cycle_year: { stem: {}, branch: { first_stem: {}, second_stem: {}, third_stem: {} } },
        sexagenary_cycle_month: { stem: {}, branch: { first_stem: {}, second_stem: {}, third_stem: {} } },
        sexagenary_cycle_day: { stem: {}, branch: { first_stem: {}, second_stem: {}, third_stem: {} } }
      ).find_by(birthday: @date)

      if @result
        # 結果が見つかった場合のみ計算処理を実行
        @year_heavenly_void = @result.sexagenary_cycle_year.heavenly_void
        @day_heavenly_void = @result.sexagenary_cycle_day.heavenly_void

        @day_stem = @result.sexagenary_cycle_day.stem
        @month_stem = @result.sexagenary_cycle_month.stem
        @year_stem = @result.sexagenary_cycle_year.stem

        @day_branch = @result.sexagenary_cycle_day.branch
        @month_branch = @result.sexagenary_cycle_month.branch
        @year_branch = @result.sexagenary_cycle_year.branch

        basic_results = build_basic_results

        @stem_unions = basic_results.stem_unions
        @year_qi_stem, @month_qi_stem, @day_qi_stem = basic_results.birth_qi
        @youth_sub_star, @middle_age_sub_star, @old_age_sub_star = basic_results.branch_and_stem_sub_star
        @abnormals = basic_results.abnormals
        @birth_voids = basic_results.birth_voids
        @has_birth_voids = has_birth_voids

        @ten_stars, @twelve_stars = build_yang_chart

        @ten_stars_relations = TenStarsRelationCalculator.call(@ten_stars)

        calculate_params = build_calculate_params
        calculator = FortuneAnalysisCalculateWrapper.new(calculate_params)

        @stem_lineage = calculator.stem_lineage
        @numerological, @beast_type, @total_energy, @numerological_structure = calculator.numerological_calculator
        @phase_method = calculator.phase_method
        @yearly_fortune = calculator.yearly_fortune
        @major_fortune = calculator.major_fortune
      end
    end
  end

  def calculate
    # 単純にリダイレクトするだけ
    redirect_to fortune_analysis_path(date: params[:date], gender: params[:gender])
  end

  private

  def build_calculate_params
    {
      result: @result,
      date: @date,
      gender: @gender,
      day_stem: @day_stem,
      month_stem: @month_stem,
      year_stem: @year_stem,
      day_branch: @day_branch,
      month_branch: @month_branch,
      year_branch: @year_branch,
      day_qi_stem: @day_qi_stem,
      month_qi_stem: @month_qi_stem,
      year_qi_stem: @year_qi_stem,
      day_heavenly_void: @day_heavenly_void
    }
  end

  # 各中殺を持つかどうか
  def has_birth_voids
    {
      has_birth_day_void: @birth_voids[:birth_day_void].present? ||
                            @birth_voids[:day_position_void].present? ||
                            @birth_voids[:day_residence_void].present?,
      has_birth_month_void: @birth_voids[:birth_month_void].present?,
      has_birth_year_void: @birth_voids[:birth_year_void].present?,
      has_compatible_void: @birth_voids[:compatible_void].present?,
      has_double_birth_void: @birth_voids[:double_birth_void].present?,
      has_complete_void: @birth_voids[:complete_void].present?
    }
  end

  def build_basic_results
    basic_results = FortuneAnalysisBasicResults.new(@day_stem,
                                                    @month_stem,
                                                    @year_stem,
                                                    @day_branch,
                                                    @month_branch,
                                                    @year_branch,
                                                    @year_heavenly_void,
                                                    @day_heavenly_void,
                                                    @date,
                                                    @result)
  end

  def build_yang_chart
    YangChartCalculator.call(@day_qi_stem,
                             @month_qi_stem,
                             @year_qi_stem,
                             @day_stem,
                             @month_stem,
                             @year_stem,
                             @day_branch,
                             @month_branch,
                             @year_branch)
  end
end
