module ApplicationHelper
  def css_classes(conditions)
    classes = conditions.select { |_class, condition| condition }.keys.join(' ')
    return  "#{classes} shape-wrapper font-bold" if conditions.values.any?
    classes
  end

  def bg_img_class(value)
    return '' unless value
    "bg-img-#{value.element_id}-#{value.yin_yang_before_type_cast}"
  end

  def red_and_bold_class(is_red_and_bold)
    is_red_and_bold ? 'color-red font-bold' : ''
  end

  def relationship_color(relationship, heavenly_void)
    formatted_content = format_relationship_terms(relationship)
    td_class = heavenly_void.present? ? 'rel-cell rel-cell-void' : 'rel-cell'
    content_tag(:td, formatted_content, class: td_class)
  end

  # 関係性用語（"干合\n半会" 等）→ サイドパネルを開くボタン群
  def format_relationship_terms(relationship)
    return ''.html_safe if relationship.blank?

    relationship.split("\n").reject(&:blank?).map { |term| relationship_term_span(term) }.join(' ').html_safe
  end

  def relationship_term_span(term)
    return ''.html_safe if term.blank?

    entry = RelationshipGlossary.lookup(term)
    # 辞書に無い文字列（天中殺マーク ⚪︎ など）は枠なしのプレーンテキスト
    return content_tag(:span, term) unless entry

    category_css = RelationshipGlossary.category_css(term)
    category_label = RelationshipGlossary.category_label(term)

    button_tag term,
               type: 'button',
               class: "rel #{category_css}",
               data: {
                 action: 'relationship-panel#open',
                 relationship_panel_term_param: term,
                 relationship_panel_category_param: category_label,
                 relationship_panel_category_css_param: category_css,
                 relationship_panel_short_param: entry['short'],
                 relationship_panel_detail_param: entry['detail']
               },
               aria: {
                 haspopup: 'dialog'
               }
  end

  def abnormal_term_button(term)
    return ''.html_safe if term.blank?

    entry = AbnormalGlossary.lookup(term)
    return content_tag(:span, term, class: 'tag-item') unless entry

    button_tag term,
               type: 'button',
               class: 'tag-item abnormal-term-button',
               data: {
                 action: 'abnormal-panel#open',
                 abnormal_panel_term_param: term,
                 abnormal_panel_category_param: entry['category'],
                 abnormal_panel_short_param: entry['short'],
                 abnormal_panel_detail_param: entry['detail']
               },
               aria: {
                 haspopup: 'dialog'
               }
  end

  def twelve_sub_star_button(star, period)
    return ''.html_safe unless star

    entry = TwelveSubStarGlossary.lookup(star.name)
    return content_tag(:span, star.name) unless entry

    period_label = TwelveSubStarGlossary.period_label(period)

    button_tag star.name,
               type: 'button',
               class: 'energy-star-button',
               data: {
                 action: 'energy-panel#open',
                 energy_panel_term_param: star.name,
                 energy_panel_reading_param: entry['reading'],
                 energy_panel_power_param: entry['power'],
                 energy_panel_period_param: period_label,
                 energy_panel_short_param: entry['short'],
                 energy_panel_basic_param: entry['basic'],
                 energy_panel_period_text_param: entry[period]
               },
               aria: {
                 haspopup: 'dialog'
               }
  end

  def birth_void_button(key, value, day_heavenly_void, css_class)
    entry = BirthVoidGlossary.lookup(key, day_heavenly_void)
    return content_tag(:span, value, class: css_class) unless entry

    button_tag value,
               type: 'button',
               class: "#{css_class} birth-void-button",
               data: {
                 action: 'birth-void-panel#open',
                 birth_void_panel_term_param: value,
                 birth_void_panel_category_param: entry['category'],
                 birth_void_panel_short_param: entry['short'],
                 birth_void_panel_detail_param: entry['detail']
               },
               aria: {
                 haspopup: 'dialog'
               }
  end

  def fortune_period_button(term, value)
    return ''.html_safe if value.blank?

    entry = BirthVoidGlossary.lookup_term(term)
    return content_tag(:span, value) unless entry

    button_tag value,
               type: 'button',
               class: 'tag-item birth-void-button',
               data: {
                 action: 'birth-void-panel#open',
                 birth_void_panel_term_param: term,
                 birth_void_panel_category_param: entry['category'],
                 birth_void_panel_short_param: entry['short'],
                 birth_void_panel_detail_param: entry['detail']
               },
               aria: {
                 haspopup: 'dialog'
               }
  end

  def natal_phase_button(term, label = nil)
    entry = NatalPhaseGlossary.lookup(term)
    display_label = label || term
    return content_tag(:span, display_label) unless entry

    normalized_term = NatalPhaseGlossary.normalize(term)

    button_tag display_label,
               type: 'button',
               class: 'natal-phase-button',
               data: {
                 action: 'natal-phase-panel#open',
                 natal_phase_panel_term_param: normalized_term,
                 natal_phase_panel_category_param: entry['category'],
                 natal_phase_panel_short_param: entry['short'],
                 natal_phase_panel_detail_param: entry['detail']
               },
               aria: {
                 haspopup: 'dialog'
               }
  end

  def beast_type_button(beast_type)
    entry = BeastTypeGlossary.lookup(beast_type)
    return content_tag(:span, beast_type) unless entry

    type_name = BeastTypeGlossary.normalize_type(beast_type)
    yin_yang_label = BeastTypeGlossary.yin_yang_label(beast_type)

    button_tag beast_type,
               type: 'button',
               class: 'beast-type-button',
               data: {
                 action: 'beast-panel#open',
                 beast_panel_term_param: "#{type_name}型",
                 beast_panel_reading_param: entry['reading'],
                 beast_panel_structure_param: entry['structure'],
                 beast_panel_stars_param: entry['stars'],
                 beast_panel_short_param: entry['short'],
                 beast_panel_detail_param: entry['detail'],
                 beast_panel_yin_yang_param: yin_yang_label,
                 beast_panel_yin_yang_detail_param: BeastTypeGlossary.yin_yang_detail(beast_type)
               },
               aria: {
                 haspopup: 'dialog'
               }
  end

  def day_pillar_header_options(sexagenary_cycle)
    entry = DayPillarGlossary.lookup(sexagenary_cycle)
    pillar_name = DayPillarGlossary.pillar_name(sexagenary_cycle)
    return {} unless entry

    {
      class: 'day-pillar-header-trigger',
      role: 'button',
      tabindex: 0,
      data: {
        action: 'click->day-pillar-panel#open keydown.enter->day-pillar-panel#open keydown.space->day-pillar-panel#open',
        day_pillar_panel_term_param: "#{pillar_name}・日番号#{entry['number']}",
        day_pillar_panel_meta_param: DayPillarGlossary.meta(entry),
        day_pillar_panel_keywords_param: entry['keywords'],
        day_pillar_panel_short_param: entry['short'],
        day_pillar_panel_detail_param: entry['detail'],
        day_pillar_panel_advice_param: entry['advice']
      },
      aria: {
        haspopup: 'dialog',
        label: "#{pillar_name}の日干支解説を開く"
      }
    }
  end

  def stem_lineage_node(stem_lineage, role_key)
    person = stem_lineage[role_key]
    return content_tag(:div) if person.blank?

    content_tag(:div, class: 'stem-lineage-node') do
      safe_join(
        [
          content_tag(:span, StemLineageGlossary.role_label(role_key), class: 'stem-lineage-role'),
          stem_lineage_person_button(person)
        ]
      )
    end
  end

  def stem_lineage_person_button(person)
    match_type = person[:origin_match_type]

    button_tag(
      type: 'button',
      class: "stem-lineage-box stem-lineage-box-#{match_type}",
      data: stem_lineage_panel_data(person),
      aria: {
        haspopup: 'dialog',
        label: "#{StemLineageGlossary.role_label(person[:key])}の六親解説を開く"
      }
    ) do
      safe_join(
        [
          content_tag(:span, "原 #{person[:origin_stem_name] || '-'} / 宿 #{person[:resolved_stem_name] || '-'}", class: 'stem-lineage-stems'),
          content_tag(:span, StemLineageGlossary.match_type_label(match_type), class: "stem-lineage-badge stem-lineage-badge-#{match_type}")
        ]
      )
    end
  end

  def stem_lineage_panel_data(person)
    {
      action: 'stem-lineage-panel#open',
      stem_lineage_panel_term_param: "#{StemLineageGlossary.role_label(person[:key])}: #{person[:text]}",
      stem_lineage_panel_meta_param: stem_lineage_panel_meta(person),
      stem_lineage_panel_match_param: stem_lineage_match_text(person),
      stem_lineage_panel_positions_param: stem_lineage_positions_text(person),
      stem_lineage_panel_method_param: stem_lineage_method_text(person),
      stem_lineage_panel_focus_param: StemLineageGlossary.role(person[:key])['focus'],
      stem_lineage_panel_reading_param: stem_lineage_result_text(person),
      stem_lineage_panel_shared_param: stem_lineage_shared_text(person),
      stem_lineage_panel_questions_param: stem_lineage_questions_text(person)
    }
  end

  def stem_lineage_panel_meta(person)
    values = [
      "原点 #{person[:origin_stem_name] || '-'}",
      "宿命 #{person[:resolved_stem_name] || '-'}",
      StemLineageGlossary.match_type_label(person[:origin_match_type])
    ]

    values.join(' / ')
  end

  def stem_lineage_match_text(person)
    entry = StemLineageGlossary.match_type(person[:origin_match_type])
    return '解説データが未登録です。' if entry.blank?

    "#{entry['short']}\n#{entry['detail']}"
  end

  def stem_lineage_positions_text(person)
    positions = person[:positions] || []
    return '宿命内に該当位置はありません。' if positions.blank?

    positions.map do |position|
      "#{position[:label]}（#{position[:area]} / #{position[:layer]}）: #{position[:stem_name]}"
    end.join("\n")
  end

  def stem_lineage_method_text(person)
    resolve_entry = StemLineageGlossary.resolve_type(person[:resolve_type])
    target = person[:target_stem_name].presence || 'なし'
    lines = ["探索干: #{target}", "#{StemLineageGlossary.resolve_type_label(person[:resolve_type])}: #{resolve_entry['detail']}"]

    if person[:resolve_type] == :place && person[:fallback_position].present?
      fallback = person[:fallback_position]
      lines << "補充場所: #{fallback[:label]}（#{fallback[:area]}）"
    end

    lines.join("\n")
  end

  def stem_lineage_result_text(person)
    lines = [
      StemLineageGlossary.role(person[:key])['reading'],
      StemLineageGlossary.role_result(person[:key], person[:origin_match_type])
    ].compact

    position_results = stem_lineage_position_result_texts(person)
    lines << "宿命内の出方:\n#{position_results.join("\n")}" if position_results.present?

    lines.join("\n\n")
  end

  def stem_lineage_position_result_texts(person)
    positions = person[:positions] || []
    grouped_positions = positions.group_by { |position| stem_lineage_position_group(position) }
    grouped_positions = grouped_positions.reject { |position_group, _grouped| position_group.blank? }

    grouped_positions.filter_map do |position_group, grouped|
      result = StemLineageGlossary.role_position_result(person[:key], person[:origin_match_type], position_group)
      next if result.blank?

      labels = grouped.map { |position| position[:label] }.join('・')
      "・#{labels}: #{result}"
    end
  end

  def stem_lineage_position_group(position)
    return position[:group] if position[:group].present?

    key = position[:key].to_s
    return :day_stem if key == 'day_stem'
    return :month_stem if key == 'month_stem'
    return :year_stem if key == 'year_stem'
    return :day_branch if key.start_with?('day_branch') || key == 'day_qi_stem'
    return :month_branch if key.start_with?('month_branch')
    return :year_branch if key.start_with?('year_branch') || key == 'year_qi_stem'

    nil
  end

  def stem_lineage_shared_text(person)
    lines = []

    if person[:shared_role_keys].present?
      shared_labels = person[:shared_role_keys].map { |key| StemLineageGlossary.role_label(key) }
      lines << "同じ干を共有: #{shared_labels.join('・')}"
      lines << StemLineageGlossary.shared_result(stem_lineage_shared_scenario(person))
    end

    if person[:multi_position]
      lines << StemLineageGlossary.multi_position_result(person[:key])
    end

    lines.compact_blank.presence&.join("\n") || '特記事項なし。'
  end

  def stem_lineage_shared_scenario(person)
    role_keys = ([person[:key]] + person[:shared_role_keys]).map(&:to_sym)

    return :father_spouse if role_keys.include?(:father) && role_keys.include?(:spouse)
    return :child_mother_in_law if role_keys.include?(:child) && role_keys.include?(:mother_in_law)
    return :child_shared if role_keys.include?(:child)
    return :core_priority if role_keys.any? { |key| StemLineageGlossary.role_priority(key) == 'core' } &&
                             role_keys.any? { |key| StemLineageGlossary.role_priority(key) == 'extended' }

    :default
  end

  def stem_lineage_questions_text(person)
    questions = StemLineageGlossary.role(person[:key])['questions'] || []
    return '確認質問は未登録です。' if questions.blank?

    questions.map { |question| "・#{question}" }.join("\n")
  end

  def stem_lineage_summary_chips(stem_lineage)
    chips = stem_lineage_summary_items(stem_lineage)
    return ''.html_safe if chips.blank?

    content_tag(:div, class: 'stem-lineage-insights', aria: { label: '六親図の注目ポイント' }) do
      safe_join(chips.map { |chip| stem_lineage_chip(chip) })
    end
  end

  def stem_lineage_summary_items(stem_lineage)
    people = StemLineageCalculator::LINEAGE_ROLE_KEYS.filter_map { |key| stem_lineage[key] }
    chips = stem_lineage_shared_group_chips(people)

    people.each do |person|
      next if person[:origin_match_type] == :exact

      chips << {
        level: person[:origin_match_type],
        text: "#{StemLineageGlossary.role_label(person[:key])}: #{StemLineageGlossary.match_type_label(person[:origin_match_type])}"
      }
    end

    people.select { |person| person[:multi_position] }.each do |person|
      chips << {
        level: :multi,
        text: "#{StemLineageGlossary.role_label(person[:key])}: 複数位置"
      }
    end

    chips
  end

  def stem_lineage_shared_group_chips(people)
    groups = Hash.new { |hash, key| hash[key] = [] }
    names = {}

    people.each do |person|
      person[:resolved_stem_ids].each do |stem_id|
        groups[stem_id] << person[:key]
        names[stem_id] = stem_lineage_resolved_stem_name(person, stem_id)
      end
    end

    groups.filter_map do |stem_id, role_keys|
      next if role_keys.uniq.size < 2

      labels = role_keys.uniq.map { |key| StemLineageGlossary.role_label(key) }
      {
        level: :shared,
        text: "#{names[stem_id]}: #{labels.join('・')}が共有"
      }
    end
  end

  def stem_lineage_chip(chip)
    content_tag(:span, chip[:text], class: "stem-lineage-insight stem-lineage-insight-#{chip[:level]}")
  end

  def stem_lineage_resolved_stem_name(person, stem_id)
    stem = person[:resolved_stems]&.find { |resolved_stem| resolved_stem[:id] == stem_id }

    stem&.dig(:name) || person[:resolved_stem_name]
  end

  def yearly_fortune_row_options(item)
    major_entry = FortuneMajorStarGlossary.lookup(item[:major_star]) || {}
    sub_entry = FortuneSubStarGlossary.lookup(item[:sub_star]) || {}
    heavenly_void = item[:heavenly_void].present?

    {
      class: 'yearly-fortune-row',
      role: 'button',
      tabindex: 0,
      aria: {
        label: yearly_fortune_row_label(item)
      },
      data: {
        action: 'click->yearly-fortune-panel#open keydown.enter->yearly-fortune-panel#open keydown.space->yearly-fortune-panel#open',
        yearly_fortune_panel_year_param: item[:year_and_age],
        yearly_fortune_panel_stem_and_branch_param: item[:stem_and_branch],
        yearly_fortune_panel_void_label_param: heavenly_void ? '天中殺年' : '通常年',
        yearly_fortune_panel_summary_param: yearly_fortune_summary(item, major_entry, heavenly_void),
        yearly_fortune_panel_major_star_param: item[:major_star],
        yearly_fortune_panel_major_keywords_param: major_entry['keywords'],
        yearly_fortune_panel_key_people_param: major_entry['key_people'],
        yearly_fortune_panel_place_people_param: major_entry['fortune_place_people'],
        yearly_fortune_panel_major_text_param: yearly_fortune_glossary_text(major_entry, heavenly_void),
        yearly_fortune_panel_sub_star_param: item[:sub_star],
        yearly_fortune_panel_sub_power_param: sub_entry['power'],
        yearly_fortune_panel_sub_keywords_param: sub_entry['keywords'],
        yearly_fortune_panel_sub_text_param: yearly_fortune_glossary_text(sub_entry, heavenly_void),
        yearly_fortune_panel_day_relationship_param: yearly_fortune_relationship_text(:day, item[:relationship][:day]),
        yearly_fortune_panel_month_relationship_param: yearly_fortune_relationship_text(:month, item[:relationship][:month]),
        yearly_fortune_panel_year_relationship_param: yearly_fortune_relationship_text(:year, item[:relationship][:year]),
        yearly_fortune_panel_void_text_param: yearly_fortune_void_text(heavenly_void)
      }
    }
  end

  def yearly_fortune_row_label(item)
    "#{item[:year_and_age]} #{item[:stem_and_branch]} の年運読み解きを開く"
  end

  def yearly_fortune_summary(item, major_entry, heavenly_void)
    key_people = major_entry['key_people'].presence || '関係人物'
    place_people = major_entry['fortune_place_people'].presence
    people_note =
      if place_people.present? && place_people != key_people
        "#{key_people}を主人物に、#{place_people}も補助的に確認します。"
      else
        "#{key_people}を主人物として確認します。"
      end
    void_note =
      if heavenly_void
        '天中殺年のため、新規開始や大きな決定は慎重に扱います。'
      else
        '通常年として、主星・従星・日月年の位相を組み合わせて読みます。'
      end

    "#{item[:year_and_age]}は#{item[:major_star]}を主星テーマに、#{item[:sub_star]}は一年のテーマを下支えします。#{people_note}日支は家庭・結果、月支は心、年支は仕事・社会の現象として確認します。#{void_note}"
  end

  def yearly_fortune_relationship_text(position, relationship)
    position_label = FortuneRelationshipGlossary.position_label(position)

    if relationship.blank?
      return "#{position_label}: 目立つ位相はありません。#{FortuneRelationshipGlossary.default_position_text(position)}"
    end

    terms = relationship.split("\n").reject(&:blank?).map do |term|
      entry = FortuneRelationshipGlossary.position_entry(term, position)
      fallback_entry = RelationshipGlossary.lookup(term)

      if entry.present?
        yearly_fortune_relationship_entry_text(term, entry)
      elsif fallback_entry.present?
        "#{term}: #{fallback_entry['short']}"
      else
        term
      end
    end

    "#{position_label}:\n#{terms.join("\n\n")}"
  end

  def yearly_fortune_relationship_entry_text(term, entry)
    text = "#{term}: #{entry['short']}"
    return text if entry['detail'].blank?

    "#{text}\n#{entry['detail']}"
  end

  def yearly_fortune_void_text(heavenly_void)
    return '該当なし。通常の年運として、主星・従星・位相法を中心に読みます。' unless heavenly_void

    '天中殺年に該当します。新しいことを始める、自分の欲望を満たす、将来につながる大きな決定をする、といった行動は慎重に扱います。位相法の出方も平常時より行き過ぎやすいため、良い位相も悪い位相も極端に振れていないかを確認します。継続している日常や積み上げてきた努力は崩さず、普段と違う衝動で動いていないかを確認します。'
  end

  def yearly_fortune_glossary_text(entry, heavenly_void)
    return '解説データが未登録です。' if entry.blank?

    short_key = heavenly_void && entry['void_short'].present? ? 'void_short' : 'short'
    detail_key = heavenly_void && entry['void_detail'].present? ? 'void_detail' : 'detail'

    "#{entry[short_key]}\n#{entry[detail_key]}"
  end
end
