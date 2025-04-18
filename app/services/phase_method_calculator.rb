class PhaseMethodCalculator
  attr_reader :day_stem,
              :month_stem,
              :year_stem,
              :day_branch,
              :month_branch,
              :year_branch,
              :all_branch_ids,
              :fortune_analysis,
              :day_analysis_id,
              :month_analysis_id,
              :year_analysis_id

  def initialize(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, fortune_analysis)
    @day_stem = day_stem
    @month_stem = month_stem
    @year_stem = year_stem
    @day_branch = day_branch
    @month_branch = month_branch
    @year_branch = year_branch
    @fortune_analysis = fortune_analysis
    @day_analysis_id = fortune_analysis.sexagenary_cycle_day_id
    @month_analysis_id = fortune_analysis.sexagenary_cycle_month_id
    @year_analysis_id = fortune_analysis.sexagenary_cycle_year_id
    @all_branch_ids = [day_branch.id, month_branch.id, year_branch.id]
  end

  def self.call(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, fortune_analysis)
    new(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, fortune_analysis).calculate
  end

  def calculate
    trine = build_trine
    half_trine = build_half_trine if trine.nil?
    combination = build_combination
    directional = build_directional
    half_directional = build_half_directional if directional.nil?
    clash = build_clash
    harm = build_harm
    punishment = build_punishment
    self_punishment =build_self_punishment
    braking = build_braking

    strong_half_trine = build_strong_half_trine(half_trine) if half_trine.present?
    ricchin = build_ricchin
    nacchin = build_nacchin(clash[:pairs]) if clash.present?
    dual_clash = build_dual_clash(clash[:pairs]) if clash.present?

    has_combined = [trine, half_trine, combination, directional, half_directional].any?(&:present?)
    has_scattered = [clash, harm, punishment, self_punishment, braking].any?(&:present?)
    has_special = [strong_half_trine, ricchin, nacchin, dual_clash].any?(&:present?)

    phase_method = {
      has_combined:,
      has_scattered:,
      has_special:,
      trine:,
      half_trine:,
      combination:,
      directional:,
      half_directional:,
      clash:,
      harm:,
      punishment:,
      self_punishment:,
      braking:,
      strong_half_trine:,
      ricchin:,
      nacchin:,
      dual_clash:
    }
  end

  private

  # 三合
  def build_trine
    Branch::TRINE_IDS.each do |key, trine_ids|
      if trine_ids.sort == all_branch_ids.sort
        return key
      end
    end

    nil
  end

  # 半会
  def build_half_trine
    pair_method_result(Branch::TRINE_IDS)
  end

  # 大半会
  # 半会の気が一致していればhashを返す
  def build_strong_half_trine(half_trine)
    stem_mapping = {
      day: day_stem,
      month: month_stem,
      year: year_stem
    }

    pairs = half_trine[:pairs]
    first_stem = stem_mapping[pairs[0]]
    second_stem = stem_mapping[pairs[1]]

    return { pairs: pairs } if first_stem.id == second_stem.id

    nil
  end

  # 支合
  def build_combination
    pair_method_result(Branch::COMBINATION_IDS)
  end

  # 方三位
  def build_directional
    Branch::DIRECTIONAL_IDS.each do |key, directional_ids|
      if directional_ids.sort == all_branch_ids.sort
        return key
      end
    end

    nil
  end

  # 準方三位
  def build_half_directional
    pair_method_result(Branch::DIRECTIONAL_IDS)
  end

  # 対冲
  def build_clash
    Branch::CLASH_IDS.each do |key, clash_ids_array|
      clash_ids_array.each do |clash_ids|
        result = pair_method_result_without_key(clash_ids)
        if result.present?
          return { key: key, pairs: result[:pairs] }
        end
      end
    end
    nil
  end

  # 害
  def build_harm
    Branch::HARM_IDS.each do |harm_ids|
      harm_result = nil
      result = pair_method_result_without_key(harm_ids)
      if result.present?
        harm_result = result[:pairs].map do |pair|
          branch_key = if pair == [:day, :month]
            "#{day_branch.name}・#{month_branch.name}"
          elsif pair == [:day, :year]
            "#{day_branch.name}・#{year_branch.name}"
          elsif pair == [:month, :year]
            "#{month_branch.name}・#{year_branch.name}"
          end

          { "#{branch_key}": pair }
          #  harm: [{亥・申: [:day, :month]}, {亥・申: [:day, :year]}],
        end

        return harm_result
      end
    end

    nil
  end

  # 刑
  def build_punishment
    Branch::PUNISHMENT_IDS.each do |key, punishment_ids|
      next if key == :self_punishment

      if key == :prosperous
        result = pair_method_result_without_key(punishment_ids)
        if result.present?
          return { key: key, pairs: result[:pairs] }
        end
      else
        if punishment_ids.sort == all_branch_ids.sort
          return { key: key, pairs: [:day, :month, :year] }
        end
      end
    end

    nil
  end

  # 自刑
  def build_self_punishment
    Branch::PUNISHMENT_IDS[:self_punishment].each do |key, punishment_ids|
      result = find_matching_pairs(punishment_ids)
      if result.present?
        return { key: key, pairs: result[:pairs] }
      end
    end

    nil
  end

  # 破
  def build_braking
    Branch::BRAKE_IDS.each do |brake_ids|
      result = pair_method_result_without_key(brake_ids)
      if result.present?
        brake_result = result[:pairs].map do |pair|
          branch_key = if pair == [:day, :month]
            "#{day_branch.name}・#{month_branch.name}"
          elsif pair == [:day, :year]
            "#{day_branch.name}・#{year_branch.name}"
          elsif pair == [:month, :year]
            "#{month_branch.name}・#{year_branch.name}"
          end

          { "#{branch_key}": pair }
        end

        return brake_result
      end
    end

    nil
  end

  # 律音
  def build_ricchin
    pairs = []
    if day_analysis_id == month_analysis_id
      pairs << [:day, :month]
    elsif day_analysis_id == year_analysis_id
      pairs << [:day, :year]
    elsif month_analysis_id == year_analysis_id
      pairs << [:month, :year]
    end

    if pairs.present?
      return { pairs: }
    end

    nil
  end

  def build_nacchin(clash_pairs)
    nacchin_pairs = []

    clash_pairs.each do |pair|
      if pair == [:day, :month] && day_stem.id == month_stem.id
        nacchin_pairs << pair
      elsif pair == [:day, :year] && day_stem.id == year_stem.id
        nacchin_pairs << pair
      elsif pair == [:month, :year] && month_stem.id == year_stem.id
        nacchin_pairs << pair
      end
    end

    if nacchin_pairs.present?
      return { pairs: nacchin_pairs }
    end

    nil
  end

  # 天剋地冲
  def build_dual_clash(clash_pairs)
    dual_clash_pairs = []
    conflicts = Stem::STEM_CONFLICTS

    clash_pairs.each do |pair|
      if pair == [:day, :month] && day_stem.yin_yang == month_stem.yin_yang && conflicts.include?(day_stem.name + month_stem.name)
        dual_clash_pairs << pair
      elsif pair == [:day, :year] && day_stem.yin_yang == year_stem.yin_yang && conflicts.include?(day_stem.name + year_stem.name)
        dual_clash_pairs << pair
      elsif pair == [:month, :year] && month_stem.yin_yang == year_stem.yin_yang && conflicts.include?(month_stem.name + year_stem.name)
        dual_clash_pairs << pair
      end
    end

    if dual_clash_pairs.present?
      return { pairs: dual_clash_pairs }
    end

    nil
  end

  # ２つがマッチする場合は、マッチする組み合わせも返す
  def pair_method_result(method_ids_obj)
    method_ids_obj.each do |key, ids|
      # 日支と月支のチェック
      if ids.include?(day_branch.id) && ids.include?(month_branch.id)
        return { key: key, pairs: [:day, :month] }
      end

      # 日支と年支のチェック
      if ids.include?(day_branch.id) && ids.include?(year_branch.id)
        return { key: key, pairs: [:day, :year] }
      end

      # 月支と年支のチェック
      if ids.include?(month_branch.id) && ids.include?(year_branch.id)
        return { key: key, pairs: [:month, :year] }
      end
    end

    nil
  end

  # 配列の場合
  def pair_method_result_without_key(method_ids)
    matching_branch_pairs = []

    # 日支と月支のチェック
    if day_branch.id != month_branch.id && method_ids.include?(day_branch.id) && method_ids.include?(month_branch.id)
      matching_branch_pairs << [:day, :month]
    end

    # 日支と年支のチェック
    if day_branch.id != year_branch.id && method_ids.include?(day_branch.id) && method_ids.include?(year_branch.id)
      matching_branch_pairs << [:day, :year]
    end

    # 月支と年支のチェック
    if month_branch.id != year_branch.id && method_ids.include?(month_branch.id) && method_ids.include?(year_branch.id)
      matching_branch_pairs << [:month, :year]
    end

    if matching_branch_pairs.any?
      return { pairs: matching_branch_pairs }
    end

    nil
  end

  # 日支、月支、年支のうち二つが同じ場合に利用する
  # 自刑で使う
  def find_matching_pairs(method_ids)
    matching_pairs = []

    method_ids.each do |id|
      # 日支と月支のチェック
      if id == day_branch.id && id == month_branch.id
        matching_pairs << [:day, :month]
      end

      # 日支と年支のチェック
      if id == day_branch.id && id == year_branch.id
        matching_pairs << [:day, :year]
      end

      # 月支と年支のチェック
      if id == month_branch.id && id == year_branch.id
        matching_pairs << [:month, :year]
      end
    end

    if matching_pairs.any?
      return { pairs: matching_pairs }
    end

    nil
  end
end
