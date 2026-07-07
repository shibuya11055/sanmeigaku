class NumerologicalHealthCalculator
  attr_reader :numerological,
              :day_stem,
              :month_branch

  def initialize(numerological, day_stem, month_branch)
    @numerological = numerological
    @day_stem = day_stem
    @month_branch = month_branch
  end

  def self.call(numerological, day_stem, month_branch)
    new(numerological, day_stem, month_branch).calculate
  end

  def calculate
    totals = element_totals
    dominant = dominant_element(totals)
    weak_elements = weakest_elements(totals)
    self_element = NumerologicalHealthGlossary.normalize_element(day_stem.element.name)

    {
      element_totals: totals,
      self_element: element_payload(self_element, totals[self_element]),
      dominant: element_payload(dominant, totals[dominant]),
      weak_elements: weak_elements.map { |element| element_payload(element, totals[element]) },
      month_branch: month_branch.name,
      dominant_branch_reading: NumerologicalHealthGlossary.dominant_branch_reading(dominant, month_branch.name),
      dominant_branch_detail: NumerologicalHealthGlossary.dominant_branch_detail(dominant, month_branch.name),
      overview: overview_text(dominant, weak_elements, self_element)
    }
  end

  private

  def element_totals
    totals = NumerologicalHealthGlossary::ELEMENT_ORDER.index_with do
      {
        points: 0,
        percentage: 0.0
      }
    end

    numerological.each_value do |data|
      element = NumerologicalHealthGlossary.normalize_element(data[:element_name])
      totals[element][:points] += data[:all_points].to_i
    end

    total_points = totals.values.sum { |data| data[:points] }
    totals.each_value do |data|
      data[:percentage] = total_points.positive? ? (data[:points] / total_points.to_f * 100).round(1) : 0.0
    end

    totals
  end

  def dominant_element(totals)
    NumerologicalHealthGlossary::ELEMENT_ORDER.max_by.with_index do |element, index|
      [totals[element][:points], index]
    end
  end

  def weakest_elements(totals)
    min_points = totals.values.map { |data| data[:points] }.min

    NumerologicalHealthGlossary::ELEMENT_ORDER.select { |element| totals[element][:points] == min_points }
  end

  def element_payload(element, total)
    {
      name: element,
      label: "#{element}性",
      points: total[:points],
      percentage: total[:percentage],
      glossary: NumerologicalHealthGlossary.element(element)
    }
  end

  def overview_text(dominant, weak_elements, self_element)
    weak_labels = weak_elements.map { |element| "#{element}性" }.join('・')

    [
      "最大気は#{dominant}性です。大きい気は若年期には強みとして使いやすい一方、年齢や環境によって燃焼しきれない時に不調として出やすくなります。",
      "最小気は#{weak_labels}です。小さい気は無理使いすると消耗しやすく、若い時期や方向が定まらない時ほど注意します。",
      "日干の五行は#{self_element}性です。運勢でこの気が弱くなる時や、この気を剋す気が強まる時は、健康注意の補助材料として見ます。"
    ].join("\n")
  end
end
