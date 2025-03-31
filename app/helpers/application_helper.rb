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
end
