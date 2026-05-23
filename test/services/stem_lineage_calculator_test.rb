require 'test_helper'

class StemLineageCalculatorTest < ActiveSupport::TestCase
  test 'same branch positions are not treated as multiple positions' do
    lineage = {
      spouse: {
        key: :spouse,
        resolved_stem_ids: [1],
        positions: [
          { key: :day_branch_third_stem, group: :day_branch },
          { key: :day_branch_second_stem, group: :day_branch }
        ]
      }
    }

    result = StemLineageCalculator.allocate.send(:enrich_lineage, lineage)

    assert_not result[:spouse][:multi_position]
  end

  test 'different position groups are treated as multiple positions' do
    lineage = {
      spouse: {
        key: :spouse,
        resolved_stem_ids: [1],
        positions: [
          { key: :day_branch_third_stem, group: :day_branch },
          { key: :month_stem, group: :month_stem }
        ]
      }
    }

    result = StemLineageCalculator.allocate.send(:enrich_lineage, lineage)

    assert result[:spouse][:multi_position]
  end
end
