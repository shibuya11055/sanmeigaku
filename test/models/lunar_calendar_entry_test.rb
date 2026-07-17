require 'test_helper'

class LunarCalendarEntryTest < ActiveSupport::TestCase
  test '2003年2月は月入日前日まで前年扱いになる' do
    assert_not LunarCalendarEntry.current_year?(Date.new(2003, 2, 1))
    assert_not LunarCalendarEntry.current_year?(Date.new(2003, 2, 2))
    assert_not LunarCalendarEntry.current_year?(Date.new(2003, 2, 3))
  end

  test '2003年2月は月入日当日以降に当年扱いになる' do
    assert LunarCalendarEntry.current_year?(Date.new(2003, 2, 4))
    assert LunarCalendarEntry.current_year?(Date.new(2003, 2, 5))
  end

  test '異なる年でも2月の月入日を境界に年を切り替える' do
    boundary_cases = {
      1926 => 4,
      1952 => 5,
      1965 => 4
    }

    boundary_cases.each do |year, entry_day|
      assert_not LunarCalendarEntry.current_year?(Date.new(year, 2, entry_day - 1))
      assert LunarCalendarEntry.current_year?(Date.new(year, 2, entry_day))
      assert LunarCalendarEntry.current_year?(Date.new(year, 2, entry_day + 1))
    end
  end
end
