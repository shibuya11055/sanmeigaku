require 'test_helper'

class SanmeigakuNatalChartCalculatorTest < ActiveSupport::TestCase
  test '2003年2月5日の命式を静的計算する' do
    result = Sanmeigaku::NatalChartCalculator.call(birth_date: Date.new(2003, 2, 5))

    assert_equal [46, 51, 20], [result.sexagenary_cycle_day_id, result.sexagenary_cycle_month_id, result.sexagenary_cycle_year_id]
    assert_equal '癸未', result.sexagenary_cycle_year.stem_and_branch
    assert_instance_of Sanmeigaku::StaticData::Result, result
  end

  test '立春前後の年柱を静的計算する' do
    before_entry = Sanmeigaku::NatalChartCalculator.call(birth_date: Date.new(2003, 2, 3))
    entry_day = Sanmeigaku::NatalChartCalculator.call(birth_date: Date.new(2003, 2, 4))

    assert_equal 19, before_entry.sexagenary_cycle_year_id
    assert_equal 20, entry_day.sexagenary_cycle_year_id
  end

  test '年番号の基準値が60の年でも立春前は前年番号になる' do
    result = Sanmeigaku::NatalChartCalculator.call(birth_date: Date.new(1983, 2, 3))

    assert_equal 59, result.sexagenary_cycle_year_id
  end

  test '対応範囲外の日付は計算しない' do
    assert_raises(ArgumentError) do
      Sanmeigaku::NatalChartCalculator.call(birth_date: Date.new(1924, 12, 31))
    end
  end

  test '前後の月入日データがない境界は詳細計算の対象外にする' do
    assert_not Sanmeigaku::NatalChartCalculator.analysis_supported?(birth_date: Date.new(1925, 1, 1), gender: 'male')
    assert_not Sanmeigaku::NatalChartCalculator.analysis_supported?(birth_date: Date.new(2044, 12, 10), gender: 'male')
    assert Sanmeigaku::NatalChartCalculator.analysis_supported?(birth_date: Date.new(2003, 2, 5), gender: 'male')
  end

  test '命式計算ではActiveRecordのSQLを発行しない' do
    queries = []
    subscriber = ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
      payload = args.last
      queries << payload[:sql] unless payload[:name] == 'SCHEMA'
    end

    Sanmeigaku::NatalChartCalculator.call(birth_date: Date.new(2003, 2, 5))
  ensure
    ActiveSupport::Notifications.unsubscribe(subscriber)
    assert_empty queries
  end

  test '鑑定画面の計算サービス一式ではActiveRecordのSQLを発行しない' do
    date = Date.new(2003, 2, 5)
    result = Sanmeigaku::NatalChartCalculator.call(birth_date: date)
    year_cycle = result.sexagenary_cycle_year
    month_cycle = result.sexagenary_cycle_month
    day_cycle = result.sexagenary_cycle_day
    basic_results = FortuneAnalysisBasicResults.new(
      day_cycle.stem, month_cycle.stem, year_cycle.stem,
      day_cycle.branch, month_cycle.branch, year_cycle.branch,
      year_cycle.heavenly_void, day_cycle.heavenly_void, date, result
    )
    year_qi_stem, month_qi_stem, day_qi_stem = basic_results.birth_qi
    calculator = FortuneAnalysisCalculateWrapper.new(
      result: result,
      date: date,
      gender: 'male',
      day_stem: day_cycle.stem,
      month_stem: month_cycle.stem,
      year_stem: year_cycle.stem,
      day_branch: day_cycle.branch,
      month_branch: month_cycle.branch,
      year_branch: year_cycle.branch,
      day_qi_stem:,
      month_qi_stem:,
      year_qi_stem:,
      day_heavenly_void: day_cycle.heavenly_void
    )
    queries = []
    subscriber = ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
      payload = args.last
      queries << payload[:sql] unless payload[:name] == 'SCHEMA'
    end

    calculator.stem_lineage
    numerological, = calculator.numerological_calculator
    natal_health = NumerologicalHealthCalculator.call(numerological, day_cycle.stem, month_cycle.branch)
    calculator.phase_method
    yearly_fortune = calculator.yearly_fortune
    major_fortune = calculator.major_fortune
    FortuneHealthForecastCalculator.call(
      day_stem: day_cycle.stem,
      month_stem: month_cycle.stem,
      year_stem: year_cycle.stem,
      day_branch: day_cycle.branch,
      month_branch: month_cycle.branch,
      year_branch: year_cycle.branch,
      yearly_fortune:,
      major_fortune:,
      natal_health:
    )
    calculator.heavenly_void_wave
  ensure
    ActiveSupport::Notifications.unsubscribe(subscriber)
    assert_empty queries
  end
end
