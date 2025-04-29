class TenStarsRelationCalculator
  attr_reader :ten_stars

  def initialize(ten_stars)
    @ten_stars = ten_stars
  end

  def self.call(ten_stars)
    new(ten_stars).calculate
  end

  def calculate
    center_id = ten_stars[:center].element_id
    synergy = TenStarSynergy.new

    top_relation = ElementRelation.find_relation(center_id, ten_stars[:north].element_id)
    right_relation = ElementRelation.find_relation(center_id, ten_stars[:east].element_id)
    bottom_relation = ElementRelation.find_relation(center_id, ten_stars[:south].element_id)
    left_relation = ElementRelation.find_relation(center_id, ten_stars[:west].element_id)

    top_state = top_relation.state
    right_state = right_relation.state
    bottom_state = bottom_relation.state
    left_state = left_relation.state

    {
      top: ElementRelation.top_icon(top_state),
      right: ElementRelation.right_icon(right_state),
      bottom: ElementRelation.bottom_icon(bottom_state),
      left: ElementRelation.left_icon(left_state),
      top_message: synergy.get_message("north.#{top_state}"),
      right_message: synergy.get_message("east.#{right_state}"),
      bottom_message: synergy.get_message("south.#{bottom_state}"),
      left_message: synergy.get_message("west.#{left_state}")
    }
  end
end
