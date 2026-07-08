require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'numerological structure button opens glossary panel' do
    structure = {
      struggle: 10,
      input: 8,
      ego: 14,
      expression: 31,
      get: 28,
      back_structure: 18,
      center_structure: 14,
      front_structure: 59,
      control_by: 10,
      generates: 39,
      control: 28,
      self: 35,
      other: 65
    }
    html = numerological_structure_button(:active, 59, nil, structure)

    assert_includes html, 'numerological-structure-button'
    assert_includes html, '能動的: 59'
    assert_includes html, 'numerological-structure-panel#open'
    assert_includes html, 'data-numerological-structure-panel-term-param="能動的"'
    assert_includes html, '前に出る構造'
    assert_includes html, '行動の動機が自分側'
  end

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

  test 'stem lineage panel data exposes reading context' do
    person = {
      key: :mother,
      text: '辛・庚',
      origin_stem_name: '辛',
      target_stem_name: '辛',
      resolved_stem_name: '庚',
      origin_match_type: :yin_yang,
      resolve_type: :yin_yang,
      positions: [
        { key: :year_stem, label: '年干', area: '父の場所', layer: '天干', stem_name: '庚' }
      ],
      fallback_position: nil,
      shared_role_keys: [:father],
      multi_position: false
    }

    data = stem_lineage_panel_data(person)

    assert_equal 'stem-lineage-panel#open', data[:action]
    assert_equal '母: 辛・庚', data[:stem_lineage_panel_term_param]
    assert_includes data[:stem_lineage_panel_meta_param], '陰陽'
    assert_includes data[:stem_lineage_panel_positions_param], '年干'
    assert_includes data[:stem_lineage_panel_reading_param], '母が陰陽干で成立'
    assert_includes data[:stem_lineage_panel_reading_param], '晩年に縁が出る'
    assert_includes data[:stem_lineage_panel_shared_param], '父'
    assert_includes data[:stem_lineage_panel_shared_param], '同じ気を複数の人物で分け合う'
    assert_includes data[:stem_lineage_panel_questions_param], '母が生活面'
  end

  test 'stem lineage result text combines role and position specific readings' do
    person = {
      key: :spouse,
      origin_match_type: :exact,
      positions: [
        { key: :day_branch_third_stem, label: '日支本元', area: '家庭・座下', layer: '地支', stem_name: '己' }
      ]
    }

    text = stem_lineage_result_text(person)

    assert_includes text, '配偶者が正干で成立'
    assert_includes text, '日支にあるため'
    assert_includes text, '家庭が安定しないと本人自身も大きく揺れます'
  end

  test 'stem lineage summary chips include shared stems and weak links' do
    stem_lineage = {
      mother: {
        key: :mother,
        resolved_stem_name: '庚',
        resolved_stem_ids: [7],
        origin_match_type: :yin_yang,
        multi_position: false
      },
      father: {
        key: :father,
        resolved_stem_name: '庚',
        resolved_stem_ids: [7],
        origin_match_type: :exact,
        multi_position: true
      }
    }

    items = stem_lineage_summary_items(stem_lineage)
    labels = items.map { |item| item[:text] }

    assert_includes labels, '庚: 母・父が共有'
    assert_includes labels, '母: 陰陽'
    assert_includes labels, '父: 複数位置'
  end

  test 'fortune health badge reflects attention level' do
    html = fortune_health_badge(level: 'attention', label: '要注意')

    assert_includes html, 'fortune-health-badge-attention'
    assert_includes html, '要注意'
  end
end
