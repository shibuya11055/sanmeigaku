require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'yearly fortune relationship text uses position specific reading' do
    day_text = yearly_fortune_relationship_text(:day, '害')
    month_text = yearly_fortune_relationship_text(:month, '害')
    year_text = yearly_fortune_relationship_text(:year, '害')

    assert_includes day_text, '日支（家庭・結果・私生活）'
    assert_includes day_text, '家庭や結果に負担'
    assert_includes day_text, '家族の不調'
    assert_includes month_text, 'ストレスや内的葛藤'
    assert_includes month_text, '欲や我が削られ'
    assert_includes year_text, '仕事や社会で受け身'
    assert_includes year_text, '指導を受ける'
  end

  test 'yearly fortune summary separates main and supplemental people' do
    item = {
      year_and_age: '2026(1歳)',
      major_star: '貫索星',
      sub_star: '天胡星'
    }
    major_entry = FortuneMajorStarGlossary.lookup('貫索星')

    summary = yearly_fortune_summary(item, major_entry, false)

    assert_includes summary, '天胡星は一年のテーマを下支えします'
    assert_includes summary, '自分自身・兄弟を主人物'
    assert_includes summary, '仕事関係者・学友も補助的に確認'
  end

  test 'yearly fortune row options expose place people' do
    item = {
      year_and_age: '2026(1歳)',
      stem_and_branch: '丙午',
      major_star: '貫索星',
      sub_star: '天胡星',
      relationship: {
        day: '害',
        month: '害',
        year: '害'
      },
      heavenly_void: nil
    }

    options = yearly_fortune_row_options(item)

    assert_equal '仕事関係者・学友', options[:data][:yearly_fortune_panel_place_people_param]
  end

  test 'yearly fortune void text mentions relationship amplification' do
    text = yearly_fortune_void_text(true)

    assert_includes text, '位相法の出方も平常時より行き過ぎ'
  end

  test 'day pillar header options open panel with day pillar reading' do
    options = day_pillar_header_options('甲子')

    assert_equal 'day-pillar-header-trigger', options[:class]
    assert_equal 'button', options[:role]
    assert_equal 0, options[:tabindex]
    assert_includes options[:data][:action], 'click->day-pillar-panel#open'
    assert_includes options[:data][:action], 'keydown.enter->day-pillar-panel#open'
    assert_equal '甲子・日番号1', options[:data][:day_pillar_panel_term_param]
    assert_equal '日番号1 / 戌亥天中殺 / 天恍星', options[:data][:day_pillar_panel_meta_param]
    assert_includes options[:data][:day_pillar_panel_keywords_param], '学習・芸術・後半運'
  end

  test 'day pillar glossary returns metadata for special pillars' do
    entry = DayPillarGlossary.lookup('甲戌')

    assert_equal '日番号11 / 申酉天中殺 / 天印星 / 日座中殺', DayPillarGlossary.meta(entry)
  end
end
