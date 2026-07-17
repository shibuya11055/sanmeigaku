require 'test_helper'

class YearlyDayNumberTest < ActiveSupport::TestCase
  test 'JS側と同じ日番号マスタを保持する' do
    assert_equal 50, YearlyDayNumber.day_number(Date.new(1953, 7, 1))
    assert_equal 18, YearlyDayNumber.day_number(Date.new(1998, 10, 1))
  end
end
