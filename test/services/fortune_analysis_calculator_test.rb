require 'test_helper'

class FortuneAnalysisCalculatorTest < ActiveSupport::TestCase
  test '2003年2月5日の命式番号を算出する' do
    calculator = FortuneAnalysisCalculator.new(Date.new(2003, 2, 5))
    year_num = calculator.send(:build_year_num)

    assert_equal 46, calculator.send(:build_day_num)
    assert_equal 51, calculator.send(:build_month_num)
    assert_equal 20, year_num
    assert_equal '癸未', CycleMapping.find(year_num).stem + CycleMapping.find(year_num).branch
  end

  test '2003年2月の年番号は月入日を境界に切り替わる' do
    assert_equal 19, year_num_for(Date.new(2003, 2, 3))
    assert_equal 20, year_num_for(Date.new(2003, 2, 4))
    assert_equal 20, year_num_for(Date.new(2003, 2, 5))
  end

  private

  def year_num_for(date)
    FortuneAnalysisCalculator.new(date).send(:build_year_num)
  end
end
