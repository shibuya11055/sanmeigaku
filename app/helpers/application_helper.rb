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
end
