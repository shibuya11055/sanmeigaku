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
    if relationship.blank?
      formatted_content = ''
    else
      formatted_content = relationship.split("\n").map do |rel|
        if rel == '天剋地冲'
          content_tag(:span, rel, style: 'color: red; font-weight: bold;')
        elsif rel == '害'
          content_tag(:span, rel, style: 'color: maroon;')
        elsif rel == '刑' || rel == '刑破'
          content_tag(:span, rel, style: 'color: maroon;')
        elsif rel == '破'
          content_tag(:span, rel, style: 'color: maroon;')
        elsif rel == '支合'
          content_tag(:span, rel, style: 'color: navy;')
        elsif rel == '半会'
          content_tag(:span, rel, style: 'color: navy;')
        elsif rel == '大半会'
          content_tag(:span, rel, style: 'color: navy; font-weight: bold;')
        elsif rel == '律音'
          content_tag(:span, rel, style: 'color: #9932CC; font-weight: bold;')
        elsif rel == '納音'
          content_tag(:span, rel, style: 'color: olive; font-weight: bold;')
        elsif rel == '干合'
          content_tag(:span, rel, style: 'color: fuchsia;')
        else
          rel
        end
      end.join(' ').html_safe
    end

    if heavenly_void.present?
      content_tag(:td, formatted_content, style: 'background: #FFF0F5;')
    else
      content_tag(:td, formatted_content)
    end
  end
end
