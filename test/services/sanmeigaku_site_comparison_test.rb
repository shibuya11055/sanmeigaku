require 'test_helper'

class SanmeigakuSiteComparisonTest < ActiveSupport::TestCase
  SITE_RESULT_2003_02_05 = {
    'insen' => %w[己 甲 癸 酉 寅 未 辛 戊 丁],
    'yousen' => %w[祿存 天南 鳳閣 石門 龍高 天貴 牽牛 天極],
    'tentyusatsu' => '寅卯天中殺'
  }.freeze

  test '比較用の日付をseed固定で再生成できる' do
    first = Sanmeigaku::SiteComparison.generate_cases(count: 30, seed: 123)
    second = Sanmeigaku::SiteComparison.generate_cases(count: 30, seed: 123)

    assert_equal first, second
    assert first.include?(Date.new(1925, 2, 4))
    assert first.include?(Date.new(2003, 2, 5))
    assert first.all? { |date| date.between?(Sanmeigaku::SiteComparison::MIN_DATE, Sanmeigaku::SiteComparison::MAX_DATE) }
  end

  test '公式サイトと同じ配列順でローカル命式を作成する' do
    result = Sanmeigaku::SiteComparison.local_result(Date.new(2003, 2, 5))

    assert_equal [46, 51, 20], [result['day_num'], result['month_num'], result['year_num']]
    assert_equal %w[己 甲 癸 酉 寅 未 辛 戊 丁], result['insen']
    assert_equal %w[祿存 天南 鳳閣 石門 龍高 天貴 牽牛 天極], result['yousen']
    assert_equal '寅卯', result['tentyusatsu']
  end

  test '公式サイト結果との比較に星名の表記差を吸収する' do
    local = Sanmeigaku::SiteComparison.local_result(Date.new(2003, 2, 5))

    assert_equal({ 'status' => 'match', 'mismatches' => [] }, Sanmeigaku::SiteComparison.compare(local:, site: SITE_RESULT_2003_02_05))
  end

  test '保存済みJSONを再計算して自動検証できる' do
    payload = {
      'results' => [
        {
          'date' => '2003-02-05',
          'site' => SITE_RESULT_2003_02_05
        }
      ]
    }

    assert_empty Sanmeigaku::SiteComparison.verify_results(payload)
  end

  test '不一致はフィールド単位で報告する' do
    local = Sanmeigaku::SiteComparison.local_result(Date.new(2003, 2, 5))
    site = SITE_RESULT_2003_02_05.merge('insen' => SITE_RESULT_2003_02_05['insen'].dup.tap { |values| values[0] = '甲' })

    comparison = Sanmeigaku::SiteComparison.compare(local:, site:)

    assert_equal 'mismatch', comparison['status']
    assert_equal 'insen', comparison['mismatches'].first['field']
  end
end
