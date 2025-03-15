class ElementRelation < ActiveHash::Base
  # iconはfont awesomeを使用

  self.data = [
    # 木
    { main_element_id: 1, sub_element_id: 1, state: 'equal' },
    { main_element_id: 1, sub_element_id: 2, state: 'generates' },
    { main_element_id: 1, sub_element_id: 3, state: 'controls' },
    { main_element_id: 1, sub_element_id: 4, state: 'controlled_by' },
    { main_element_id: 1, sub_element_id: 5, state: 'generated_by' },
    # 火
    { main_element_id: 2, sub_element_id: 1, state: 'generated_by' },
    { main_element_id: 2, sub_element_id: 2, state: 'equal' },
    { main_element_id: 2, sub_element_id: 3, state: 'generates' },
    { main_element_id: 2, sub_element_id: 4, state: 'controls' },
    { main_element_id: 2, sub_element_id: 5, state: 'controlled_by' },
    # 土
    { main_element_id: 3, sub_element_id: 1, state: 'controlled_by' },
    { main_element_id: 3, sub_element_id: 2, state: 'generated_by' },
    { main_element_id: 3, sub_element_id: 3, state: 'equal' },
    { main_element_id: 3, sub_element_id: 4, state: 'generates' },
    { main_element_id: 3, sub_element_id: 5, state: 'controls' },
    # 金
    { main_element_id: 4, sub_element_id: 1, state: 'controls' },
    { main_element_id: 4, sub_element_id: 2, state: 'controlled_by' },
    { main_element_id: 4, sub_element_id: 3, state: 'generated_by' },
    { main_element_id: 4, sub_element_id: 4, state: 'equal' },
    { main_element_id: 4, sub_element_id: 5, state: 'generates' },
    # 水
    { main_element_id: 5, sub_element_id: 1, state: 'generates' },
    { main_element_id: 5, sub_element_id: 2, state: 'controls' },
    { main_element_id: 5, sub_element_id: 3, state: 'controlled_by' },
    { main_element_id: 5, sub_element_id: 4, state: 'generated_by' },
    { main_element_id: 5, sub_element_id: 5, state: 'equal' }
  ]

  def self.find_relation(main_elm_id, sub_elm_id)
    self.find_by(main_element_id: main_elm_id, sub_element_id: sub_elm_id)
  end

  def self.top_icon(state)
    case state
    when 'equal'
      'fa-solid fa-grip-lines-vertical'
    when 'generates'
      'fa-solid fa-arrow-up'
    when 'generated_by'
      'fa-solid fa-arrow-down'
    when 'controls'
      'fa-solid fa-angles-up'
    when 'controlled_by'
      'fa-solid fa-angles-down'
    end
  end

  def self.right_icon(state)
    case state
    when 'equal'
      'fa-solid fa-equals'
    when 'generates'
      'fa-solid fa-arrow-right'
    when 'generated_by'
      'fa-solid fa-arrow-left'
    when 'controls'
      'fa-solid fa-angles-right'
    when 'controlled_by'
      'fa-solid fa-angles-left'
    end
  end

  def self.left_icon(state)
    case state
    when 'equal'
      'fa-solid fa-equals'
    when 'generates'
      'fa-solid fa-arrow-left'
    when 'generated_by'
      'fa-solid fa-arrow-right'
    when 'controls'
      'fa-solid fa-angles-left'
    when 'controlled_by'
      'fa-solid fa-angles-right'
    end
  end

  def self.bottom_icon(state)
    case state
    when 'equal'
      'fa-solid fa-grip-lines-vertical'
    when 'generates'
      'fa-solid fa-arrow-down'
    when 'generated_by'
      'fa-solid fa-arrow-up'
    when 'controls'
      'fa-solid fa-angles-down'
    when 'controlled_by'
      'fa-solid fa-angles-up'
    end
  end
end
