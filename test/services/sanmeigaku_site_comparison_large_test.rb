require 'test_helper'

class SanmeigakuSiteComparisonLargeTest < ActiveSupport::TestCase
  FIXTURE_PATH = Rails.root.join('test/fixtures/sanmeigaku_site_comparison/results_1000.json')
  EXPECTED_MISMATCH_DATES = %w[1964-09-07].freeze

  test '保存済み1000件の公式サイト結果を外部アクセスなしで再検証できる' do
    payload = JSON.parse(File.read(FIXTURE_PATH))

    assert_equal 1_000, payload.fetch('results').length
    failures = Sanmeigaku::SiteComparison.verify_results(payload)

    assert_equal EXPECTED_MISMATCH_DATES, failures.map { |failure| failure.fetch('date') }
  end
end
