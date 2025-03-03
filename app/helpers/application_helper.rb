module ApplicationHelper
  def css_classes(conditions)
    conditions.select { |_class, condition| condition }.keys.join(' ')
  end
end
