class NumerologicalCalculator
  attr_reader :original_linage,
              :day_stem,
              :month_stem,
              :year_stem,
              :day_branch,
              :month_branch,
              :year_branch,
              :energy_mapping_hash

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
  end

  def self.call(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch)
    new(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch).calculate
  end

  def calculate
    @stem_ids = stem_ids

    build_data
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
    stems = Stem.preload(:element).order(:id)
    stem_data = stems.each_with_object({}) do |stem, hash|
      element_name = stem.element.name
      day_branch_point = day_branch_point(stem.id)
      month_branch_point = month_branch_point(stem.id)
      year_branch_point = year_branch_point(stem.id)
      point_sum = day_branch_point + month_branch_point + year_branch_point
      stem_count = stem_ids.count(stem.id)
      all_points = point_sum * stem_count

      hash[stem.name] = {
        element_name:,
        day_branch_point:,
        month_branch_point:,
        year_branch_point:,
        point_sum:,
        stem_count:,
        all_points:
      }
    end

    total_all_points = stem_data.values.sum { |data| data[:all_points] }
    stem_data.each_with_index do |(key, value), index|
      value[:percentage] = (value[:all_points] / total_all_points.to_f * 100).round(1)
      if index.odd?
        _, pre_value = stem_data.to_a[index-1]
        element_percentage = ((pre_value[:all_points] + value[:all_points]) / total_all_points.to_f * 100).round(1)
        pre_value[:element_percentage] = "#{pre_value[:element_name]}\n#{element_percentage}"
      end
    end

    stem_data
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
