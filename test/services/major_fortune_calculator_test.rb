require 'test_helper'

class MajorFortuneCalculatorTest < ActiveSupport::TestCase
  Result = Struct.new(:sexagenary_cycle_month_id)

  test '1973年9月24日男性の初旬は5歳の庚申になる' do
    first_age, first_cycle = major_fortune_start(Date.new(1973, 9, 24), 'male')

    assert_equal 5, first_age
    assert_equal '庚申', first_cycle.stem + first_cycle.branch
  end

  test '1947年6月25日男性の初旬は6歳の乙巳になる' do
    first_age, first_cycle = major_fortune_start(Date.new(1947, 6, 25), 'male')

    assert_equal 6, first_age
    assert_equal '乙巳', first_cycle.stem + first_cycle.branch
  end

  test '逆行は当月月入日前なら前月月入日からの日数で初旬年齢を算出する' do
    first_age, first_cycle = major_fortune_start(Date.new(1973, 9, 7), 'male')

    assert_equal 10, first_age
    assert_equal '己未', first_cycle.stem + first_cycle.branch
  end

  test '順行は当月月入日前なら当月月入日までの日数で初旬年齢を算出する' do
    first_age, = major_fortune_start(Date.new(1996, 3, 4), 'male')

    assert_equal 1, first_age
  end

  test '順行は当月月入日以降なら翌月月入日までの日数で初旬年齢を算出する' do
    dates = [
      [Date.new(1977, 4, 5), 'female'],
      [Date.new(1982, 6, 7), 'male'],
      [Date.new(1996, 3, 5), 'male'],
      [Date.new(2001, 7, 7), 'female'],
      [Date.new(2013, 12, 7), 'female']
    ]

    dates.each do |date, gender|
      first_age, = major_fortune_start(date, gender)

      assert_equal 10, first_age, "#{date} #{gender}"
    end
  end

  test '1947年6月25日は性別によって大運の順逆が切り替わる' do
    male_age, male_cycle = major_fortune_start(Date.new(1947, 6, 25), 'male')
    female_age, female_cycle = major_fortune_start(Date.new(1947, 6, 25), 'female')

    assert_equal [6, '乙巳'], [male_age, male_cycle.stem + male_cycle.branch]
    assert_equal [4, '丁未'], [female_age, female_cycle.stem + female_cycle.branch]
  end

  private

  def major_fortune_start(date, gender)
    fortune_analysis_calculator = FortuneAnalysisCalculator.new(date)
    month_num = fortune_analysis_calculator.send(:build_month_num)
    year_num = fortune_analysis_calculator.send(:build_year_num)
    year_stem_name = CycleMapping.find(year_num).stem
    year_stem = StemDefinition.find_by(name: year_stem_name)
    calculator = MajorFortuneCalculator.new(
      date,
      Result.new(month_num),
      gender,
      nil,
      nil,
      year_stem,
      nil,
      nil,
      nil,
      ''
    )

    is_reverse_sequence = calculator.send(:build_reverse_sequence)
    calculator.instance_variable_set(:@is_reverse_sequence, is_reverse_sequence)
    first_num = calculator.send(:build_first_num)
    first_age = calculator.send(:build_first_age)

    [first_age, CycleMapping.find(first_num)]
  end
end
