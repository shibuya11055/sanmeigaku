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
end
