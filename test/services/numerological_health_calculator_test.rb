require 'test_helper'

class NumerologicalHealthCalculatorTest < ActiveSupport::TestCase
  ElementLike = Struct.new(:name)
  StemLike = Struct.new(:element)
  BranchLike = Struct.new(:name)

  test 'dominant tie uses later element order and resolves month branch reading' do
    numerological = {
      '甲' => { element_name: '木', all_points: 20 },
      '乙' => { element_name: '木', all_points: 10 },
      '丙' => { element_name: '火', all_points: 10 },
      '丁' => { element_name: '火', all_points: 10 },
      '戊' => { element_name: '土', all_points: 10 },
      '己' => { element_name: '土', all_points: 10 },
      '庚' => { element_name: '金', all_points: 2 },
      '辛' => { element_name: '金', all_points: 3 },
      '壬' => { element_name: '水', all_points: 15 },
      '癸' => { element_name: '水', all_points: 15 }
    }
    day_stem = StemLike.new(ElementLike.new('金'))
    month_branch = BranchLike.new('午')

    result = NumerologicalHealthCalculator.call(numerological, day_stem, month_branch)

    assert_equal '水', result[:dominant][:name]
    assert_equal '金', result[:weak_elements].first[:name]
    assert_equal '午', result[:month_branch]
    assert_includes result[:dominant_branch_reading], '肺・気管支'
    assert_includes result[:dominant_branch_detail], '体力や体質が年齢によって大きく変化する'
    assert_includes result[:overview], '日干の五行は金性'
  end
end
