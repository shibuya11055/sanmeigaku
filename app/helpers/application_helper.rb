module ApplicationHelper
  def css_classes(conditions)
    conditions.select { |_class, condition| condition }.keys.join(' ')
  end

  def bg_img_class(value)
    return '' unless value
    "bg-img-#{value.element_id}-#{value.yin_yang_before_type_cast}"
  end
end
