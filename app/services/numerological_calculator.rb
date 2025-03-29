class NumerologicalCalculator
  attr_reader :original_linage,
              :day_stem,
              :month_stem,
              :year_stem,
              :day_branch,
              :month_branch,
              :year_branch,
              :energy_mapping_hash,
              :stem_ten_star_mapping_hash,
              :init_stems

  def initialize(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch)
    @day_stem = day_stem
    @month_stem = month_stem
    @year_stem = year_stem
    @day_branch = day_branch
    @month_branch = month_branch
    @year_branch = year_branch
    stem_twelve_star_mapping = StemTwelveStarMapping.eager_load(:twelve_sub_star)
                                                    .where(branch_id: [day_branch.id, month_branch.id, year_branch.id])

    @energy_mapping_hash = stem_twelve_star_mapping.each_with_object({}) do |mapping, hash|
      hash[[mapping.stem_id, mapping.branch_id]] = mapping.twelve_sub_star.energy
    end

    stem_ten_star_mapping = StemTenStarMapping.eager_load(:ten_major_star)
    @stem_ten_star_mapping_hash = stem_ten_star_mapping.all.each_with_object({}) do |mapping, hash|
      hash[[mapping.main_stem_id, mapping.sub_stem_id]] = mapping.ten_major_star
    end

    @init_stems = Stem.all.order(:id)
  end

  def self.call(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch)
    new(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch).calculate
  end

  def calculate
    @stem_ids = stem_ids

    stem_data, beast_type, total_energy = build_data
    yang_structure = build_yang_structure(stem_data)

    [stem_data, beast_type, total_energy, yang_structure]
  end

  private

  def stem_ids
    day_branch_stem_ids = day_branch.stem_ids
    month_branch_stem_ids = month_branch.stem_ids
    year_branch_stem_ids = year_branch.stem_ids

    stem_ids = [day_stem.id, month_stem.id, year_stem.id] +
                day_branch_stem_ids +
                month_branch_stem_ids +
                year_branch_stem_ids

    stem_ids.compact.sort
  end

  def build_data
    stems = init_stems.preload(:element)
    stem_data = stems.each_with_object({}) do |stem, hash|
      element_name = stem.element.name
      day_branch_point = day_branch_point(stem.id)
      month_branch_point = month_branch_point(stem.id)
      year_branch_point = year_branch_point(stem.id)
      point_sum = day_branch_point + month_branch_point + year_branch_point
      stem_count = stem_ids.count(stem.id)
      all_points = point_sum * stem_count
      ten_major_star = stem_ten_star_mapping_hash[[day_stem.id, stem.id]]

      hash[stem.name] = {
        stem_id: stem.id,
        element_name:,
        day_branch_point:,
        month_branch_point:,
        year_branch_point:,
        point_sum:,
        stem_count:,
        all_points:,
        ten_major_star:
      }
    end

    total_all_points = stem_data.values.sum { |data| data[:all_points] }
    stem_data.each_with_index do |(key, value), index|
      # 割合を計算
      value[:percentage] = (value[:all_points] / total_all_points.to_f * 100).round(1)
      # 前の要素と合計して五行の割合を計算
      if index.odd?
        _, pre_value = stem_data.to_a[index-1]
        element_percentage = ((pre_value[:all_points] + value[:all_points]) / total_all_points.to_f * 100).round(1)
        pre_value[:element_percentage] = "#{pre_value[:element_name]}\n#{element_percentage}"
      end
    end

    star_pair_percentages = {
      north: calculate_star_pair_percentage(stem_data, [9, 10]),
      east: calculate_star_pair_percentage(stem_data, [5, 6]),
      south: calculate_star_pair_percentage(stem_data, [3, 4]),
      west: calculate_star_pair_percentage(stem_data, [7, 8]),
      center: calculate_star_pair_percentage(stem_data, [1, 2])
    }

    beast_type = beast_type(star_pair_percentages)
    total_energy = stem_data.values.map{ |v| v[:all_points] }.sum


    [stem_data, beast_type, total_energy]
  end

  def calculate_star_pair_percentage(stem_data, ten_major_star_ids)
    matching_data = stem_data.select { |_, data| ten_major_star_ids.include?(data[:ten_major_star]&.id) }
    matching_data.values.sum { |data| data[:percentage] }.to_f
  end

  def beast_type(star_pair_percentages)
    dominant = star_pair_percentages.max_by { |_, percentage| percentage }
    beasts_type = case dominant[0]  # dominantの最初の要素（キー）を使用
    when :north then '玄武'
    when :east  then '青龍'
    when :south then '朱雀'
    when :west  then '白虎'
    when :center then '騰陀'
    end

    yin_sum = star_pair_percentages[:north] + star_pair_percentages[:west]
    yang_sum = star_pair_percentages[:east] + star_pair_percentages[:south]
    yin_sum < yang_sum ? "#{beasts_type}（陽型）" : "#{beasts_type}（陰型）"
  end

  def build_yang_structure(stem_data)
    # 手動で深いコピー
    dup_stem_data = stem_data.transform_values do |value|
      value.dup
    end

    # 日干のポイントを省く
    dup_stem_data.each do |key, value|
      if value[:stem_id] == day_stem.id
        value[:stem_count] -= 1
        value[:all_points] -= value[:point_sum]
      end
    end

    total_all_points = dup_stem_data.values.sum { |data| data[:all_points] }

    dup_stem_data.each do |key, value|
      value[:yang_energy] = (value[:all_points] / total_all_points.to_f * 100).round
      value[:type] = yang_structure_first_row(value[:ten_major_star].id)
    end

    # STRUCTURE_IDSの順序で並び替え、元のキーを保持
    sorted_pairs = TenMajorStar::STRUCTURE_IDS.map do |id|
      dup_stem_data.find { |key, data| data[:ten_major_star].id == id }
    end

    # 並び替えた順序で新しいハッシュを作成（元のキーを保持）
    dup_stem_data = sorted_pairs.to_h

    dup_stem_data_values = dup_stem_data.values

    struggle_point = dup_stem_data_values.sum { |data| data[:type] == :struggle ? data[:yang_energy] : 0 }
    input_point = dup_stem_data_values.sum { |data| data[:type] == :input ? data[:yang_energy] : 0 }
    ego_point = dup_stem_data_values.sum { |data| data[:type] == :ego ? data[:yang_energy] : 0 }
    expression_point = dup_stem_data_values.sum { |data| data[:type] == :expression ?  data[:yang_energy] : 0 }
    get_point = dup_stem_data_values.sum { |data| data[:type] == :get ? data[:yang_energy] : 0 }
    self_point = dup_stem_data_values.sum { |data| TenMajorStar::SELF_IDS.include?(data[:ten_major_star].id) ?  data[:yang_energy] : 0 }
    other_point = dup_stem_data_values.sum { |data| TenMajorStar::OTHER_IDS.include?(data[:ten_major_star].id) ? data[:yang_energy] : 0 }

    yang_structure = {
      stem_names: dup_stem_data.keys,
      stem_count: dup_stem_data_values.map { |data| data[:stem_count] },
      stem_point: dup_stem_data_values.map { |data| data[:yang_energy] },
      ten_major_star_name: dup_stem_data_values.map { |data| data[:ten_major_star].name },
      struggle: struggle_point,
      input: input_point,
      ego: ego_point,
      expression: expression_point,
      get: get_point,
      back_structure: struggle_point + input_point,
      center_structure: ego_point,
      front_structure: expression_point + get_point,
      control_by: struggle_point,
      generates: input_point + expression_point,
      control: get_point,
      self: self_point,
      other: other_point
    }

    yang_structure
  end

  def yang_structure_first_row(ten_major_star_id)
    case ten_major_star_id
    when 7, 8 then :struggle
    when 9, 10 then :input
    when 1, 2 then :ego
    when 3, 4 then :expression
    when 5, 6 then :get
    end
  end

  def day_branch_point(stem_id)
    energy_mapping_hash[[stem_id, day_branch.id]] || 0
  end

  def month_branch_point(stem_id)
    energy_mapping_hash[[stem_id, month_branch.id]] || 0
  end

  def year_branch_point(stem_id)
    energy_mapping_hash[[stem_id, year_branch.id]] || 0
  end
end
