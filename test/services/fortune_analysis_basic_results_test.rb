require 'test_helper'

class FortuneAnalysisBasicResultsTest < ActiveSupport::TestCase
  QiBranch = Struct.new(
    :first_stem,
    :first_stem_period_day,
    :second_stem,
    :second_stem_period_day,
    :third_stem
  )

  test '1947年6月25日の月支蔵干は境界日を含めて己になり中心星は禄存星になる' do
    month_branch = QiBranch.new(nil, nil, '己', 19, '丁')
    calculator = FortuneAnalysisBasicResults.allocate

    month_qi_stem = calculator.send(:calculate_qi, 19, month_branch)

    assert_equal '己', month_qi_stem
    assert_equal '禄存星', MajorStarMapping.find_by(main_stem: '乙', sub_stem: month_qi_stem).ten_major_star
  end
end
