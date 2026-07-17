class FortuneHealthForecastCalculator
  LEGAL_RELATIONSHIP_TERMS = %w[支合 半会 大半会 方三位 準方位].freeze

  attr_reader :day_stem,
              :month_stem,
              :year_stem,
              :day_branch,
              :month_branch,
              :year_branch,
              :yearly_fortune,
              :major_fortune,
              :natal_health

  def initialize(params)
    @day_stem = params[:day_stem]
    @month_stem = params[:month_stem]
    @year_stem = params[:year_stem]
    @day_branch = params[:day_branch]
    @month_branch = params[:month_branch]
    @year_branch = params[:year_branch]
    @yearly_fortune = params[:yearly_fortune]
    @major_fortune = params[:major_fortune]
    @natal_health = params[:natal_health]
  end

  def self.call(params)
    new(params).calculate
  end

  def calculate
    major_rows = build_major_rows
    yearly_rows = build_yearly_rows(major_rows)

    {
      major_fortune: enrich_rows(major_rows, :major).map { |row| row[:item] },
      yearly_fortune: enrich_rows(yearly_rows, :yearly).map { |row| row[:item] }
    }
  end

  private

  def build_major_rows
    major_fortune.map do |item|
      period_stem = stem_for(item[:stem])
      period_branch = branch_for(item[:branch])
      branches = natal_branches + [period_branch].compact
      stems = natal_stems + [period_stem].compact

      build_row(item, stems, branches, period_branch)
    end
  end

  def build_yearly_rows(major_rows)
    yearly_fortune.map do |item|
      period_stem = stem_for(item[:stem])
      period_branch = branch_for(item[:branch])
      major_row = major_row_for_age(major_rows, item[:age])
      branches = natal_branches + [major_row&.dig(:period_branch), period_branch].compact
      stems = natal_stems + [major_row&.dig(:period_stem), period_stem].compact

      build_row(item, stems, branches, period_branch)
    end
  end

  def build_row(item, stems, branches, period_branch)
    {
      item: item,
      period_stem: stem_for(item[:stem]),
      period_branch: period_branch,
      totals: element_totals(stems, branches),
      seasonal_biases: seasonal_biases(branches),
      harm_notes: harm_notes(item[:relationship], period_branch)
    }
  end

  def enrich_rows(rows, period)
    low_threshold = low_energy_threshold(rows)

    rows.map do |row|
      row[:item] = row[:item].merge(health: health_payload(row, low_threshold, period))
      row
    end
  end

  def health_payload(row, low_threshold, period)
    flags = health_flags(row, low_threshold)
    level = health_level(flags)
    totals = row[:totals]
    dominant = dominant_element(totals)
    weak = weakest_element(totals)
    period_label = period == :major ? '大運' : '年運'

    {
      level: level,
      label: health_label(level),
      summary: health_summary(period_label, totals, dominant, weak, flags),
      detail: health_detail(period_label, row, flags, dominant),
      chips: health_chips(flags, row, dominant)
    }
  end

  def health_flags(row, low_threshold)
    totals = row[:totals]
    dominant = dominant_element(totals)
    self_element = natal_health[:self_element][:name]
    dominant_percentage = totals[dominant][:percentage]
    self_percentage = totals[self_element][:percentage]
    controlled_by_self = NumerologicalHealthGlossary.controlled_by(self_element)
    relationship_text = relationship_text(row[:item][:relationship])

    {
      low_energy: totals[:total] <= low_threshold,
      contracted: contracted?(totals),
      prominent: dominant_percentage >= 35.0,
      self_suppressed: dominant == controlled_by_self && self_percentage <= 18.0,
      harm: relationship_text.include?('害'),
      clash: relationship_text.include?('対冲'),
      punishment: relationship_text.include?('刑'),
      heavenly_void: row[:item][:heavenly_void].present?,
      legal_with_low_energy: legal_relationship?(relationship_text) && totals[:total] <= low_threshold,
      seasonal_bias: row[:seasonal_biases].present?
    }
  end

  def health_level(flags)
    score = 0
    score += 2 if flags[:low_energy]
    score += 2 if flags[:self_suppressed]
    score += 2 if flags[:harm] || flags[:clash]
    score += 1 if flags[:punishment] || flags[:heavenly_void]
    score += 1 if flags[:prominent] || flags[:contracted]
    score += 1 if flags[:legal_with_low_energy] || flags[:seasonal_bias]

    return 'attention' if score >= 4
    return 'watch' if score >= 2

    'normal'
  end

  def health_label(level)
    case level
    when 'attention' then '要注意'
    when 'watch' then '注意'
    else '安定'
    end
  end

  def health_summary(period_label, totals, dominant, weak, flags)
    base = "#{period_label}込みの五行では、最大は#{dominant}性#{totals[dominant][:percentage]}%、最小は#{weak}性#{totals[weak][:percentage]}%、総量は#{totals[:total]}です。"

    if flags[:low_energy]
      "#{base}この期間群の中では総量が低めなので、無理に動きすぎない読みを優先します。"
    elsif flags[:prominent]
      "#{base}一つの気が突出しているため、その気を健全に燃焼できているかを確認します。"
    else
      "#{base}強い健康注意条件は少なめですが、位相法と天中殺は補助材料として確認します。"
    end
  end

  def health_detail(period_label, row, flags, dominant)
    lines = []
    lines << '総エネルギーが低い時は、能力発揮や奉仕に回りやすく、半会・支合などで気持ちが前に出ると反動が出やすくなります。' if flags[:low_energy]
    lines << "日干の#{natal_health[:self_element][:label]}が弱く、それを剋す気が強まっています。本人の健康やトラブルを優先して確認します。" if flags[:self_suppressed]
    lines << "突出している#{dominant}性は、不完全燃焼時に#{NumerologicalHealthGlossary.element(dominant)['organs']}へ出やすい象意として見ます。" if flags[:prominent]
    lines << "#{period_label}に害が出ています。受け身・奉仕・無理をしない対応で負担を逃がせているかを確認します。" if flags[:harm]
    lines << "#{period_label}に対冲が出ています。分断や方向転換による神経疲労、事故・怪我の注意を補助的に見ます。" if flags[:clash]
    lines << "#{period_label}に刑が出ています。摩擦や無理な緊張が身体化していないか確認します。" if flags[:punishment]
    lines << '天中殺が重なります。精神的な乱れや判断力低下から、事故・怪我・既存不調の悪化に注意します。' if flags[:heavenly_void]
    lines << '低エネルギー時に合法が重なります。気持ちが前に出て動きすぎる反動を確認します。' if flags[:legal_with_low_energy]
    lines.concat(row[:seasonal_biases].map { |bias| bias[:reading] })
    lines.concat(row[:harm_notes].map { |note| "#{note[:position]}の害: #{note[:organ]}。#{note[:reading]}" })
    lines << '医療判断ではなく、鑑定時に生活習慣・ストレス・既往歴を確認するための補助情報です。'

    lines.join("\n")
  end

  def health_chips(flags, row, dominant)
    chips = []
    chips << '総量低め' if flags[:low_energy]
    chips << "#{dominant}性突出" if flags[:prominent]
    chips << '主気が剋される' if flags[:self_suppressed]
    chips << '害' if flags[:harm]
    chips << '対冲' if flags[:clash]
    chips << '刑' if flags[:punishment]
    chips << '天中殺' if flags[:heavenly_void]
    chips << '低量+合法' if flags[:legal_with_low_energy]
    chips.concat(row[:seasonal_biases].map { |bias| "#{bias[:season]}偏り" })

    chips
  end

  def element_totals(stems, branches)
    stem_ids = (stems.map(&:id) + branches.flat_map(&:stem_ids)).compact
    branch_ids = branches.map(&:id)
    totals = NumerologicalHealthGlossary::ELEMENT_ORDER.index_with { { points: 0, percentage: 0.0 } }

    stems_by_id.each_value do |stem|
      point_sum = branch_ids.sum { |branch_id| energy_mapping[[stem.id, branch_id]].to_i }
      stem_count = stem_ids.count(stem.id)
      totals[stem.element.name][:points] += point_sum * stem_count
    end

    total_points = totals.values.sum { |data| data[:points] }
    totals.each_value do |data|
      data[:percentage] = total_points.positive? ? (data[:points] / total_points.to_f * 100).round(1) : 0.0
    end
    totals[:total] = total_points

    totals
  end

  def low_energy_threshold(rows)
    totals = rows.map { |row| row[:totals][:total] }.sort
    index = [2, totals.size - 1].min

    totals[index] || 0
  end

  def dominant_element(totals)
    NumerologicalHealthGlossary::ELEMENT_ORDER.max_by.with_index do |element, index|
      [totals[element][:points], index]
    end
  end

  def weakest_element(totals)
    NumerologicalHealthGlossary::ELEMENT_ORDER.min_by do |element|
      totals[element][:points]
    end
  end

  def contracted?(totals)
    values = NumerologicalHealthGlossary::ELEMENT_ORDER.map { |element| totals[element][:points] }
    return false if totals[:total].zero?

    ((values.max - values.min) / totals[:total].to_f) <= 0.12
  end

  def legal_relationship?(relationship_text)
    LEGAL_RELATIONSHIP_TERMS.any? { |term| relationship_text.include?(term) }
  end

  def relationship_text(relationship)
    relationship.to_h.values.compact.join("\n")
  end

  def seasonal_biases(branches)
    counts = branches.filter_map { |branch| NumerologicalHealthGlossary.season_for_branch(branch.name) }.tally

    counts.filter_map do |season, count|
      next if count < 3

      entry = NumerologicalHealthGlossary.season_bias(season)
      {
        season: season,
        body: entry['body'],
        reading: entry['reading']
      }
    end
  end

  def harm_notes(relationship, period_branch)
    return [] unless period_branch

    {
      '日支' => [relationship[:day], day_branch],
      '月支' => [relationship[:month], month_branch],
      '年支' => [relationship[:year], year_branch]
    }.filter_map do |position, (terms, natal_branch)|
      next unless terms.to_s.include?('害')

      entry = NumerologicalHealthGlossary.harm_pair(natal_branch.name, period_branch.name)
      next unless entry

      {
        position: position,
        organ: entry['organ'],
        reading: entry['reading']
      }
    end
  end

  def major_row_for_age(major_rows, age)
    age = age.to_i
    candidates = major_rows.select { |row| row[:item][:age].to_i <= age }

    candidates.max_by { |row| row[:item][:age].to_i } || major_rows.first
  end

  def natal_stems
    [day_stem, month_stem, year_stem]
  end

  def natal_branches
    [day_branch, month_branch, year_branch]
  end

  def stem_for(name)
    stems_by_name[name.to_s]
  end

  def branch_for(name)
    branches_by_name[name.to_s]
  end

  def stems_by_name
    @stems_by_name ||= Sanmeigaku::StaticData.stems.index_by(&:name)
  end

  def stems_by_id
    @stems_by_id ||= stems_by_name.values.index_by(&:id)
  end

  def branches_by_name
    @branches_by_name ||= Sanmeigaku::StaticData.branches.index_by(&:name)
  end

  def energy_mapping
    @energy_mapping ||= Sanmeigaku::StaticData.stems.each_with_object({}) do |stem, hash|
      Sanmeigaku::StaticData.branches.each do |branch|
        hash[[stem.id, branch.id]] = Sanmeigaku::StaticData.energy(stem.id, branch.id)
      end
    end
  end
end
