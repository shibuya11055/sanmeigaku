class StemLineageCalculator
  LINEAGE_ROLE_KEYS = [
    :mother,
    :father,
    :m_grandmother,
    :m_grandfather,
    :f_grandmother,
    :f_grandfather,
    :spouse,
    :mother_in_law,
    :father_in_law,
    :child,
    :child_spouse,
    :siblings
  ].freeze

  attr_reader :original_linage,
              :day_stem,
              :month_stem,
              :year_stem,
              :day_branch,
              :month_branch,
              :year_branch,
              :year_qi_stem,
              :day_qi_stem,
              :gender

  def initialize(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, year_qi_stem, day_qi_stem, gender)
    @day_stem = day_stem
    @month_stem = month_stem
    @year_stem = year_stem
    @day_branch = day_branch
    @month_branch = month_branch
    @year_branch = year_branch
    @year_qi_stem = year_qi_stem
    @day_qi_stem = day_qi_stem
    @gender = gender
    @original_linage = Sanmeigaku::StaticData.lineage_for(day_stem)
  end

  def self.call(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, year_qi_stem, day_qi_stem, gender)
    new(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, year_qi_stem, day_qi_stem, gender).calculate
  end

  def calculate
    @having_stem_ids = natal_stem_positions.map { |position| position[:stem_id] }

    @mother = build_mother
    @mother_stem = @mother[:resolved_stem]
    @father = build_father
    @father_stem = @father[:resolved_stem]
    @m_grandmother = build_m_grandmother
    @m_grandmother_stem = @m_grandmother[:resolved_stem]
    @m_grandfather = build_m_grandfather
    @m_grandfather_stem = @m_grandfather[:resolved_stem]
    @f_grandmother = build_f_grandmother
    @f_grandmother_stem = @f_grandmother[:resolved_stem]
    @f_grandfather = build_f_grandfather
    @f_grandfather_stem = @f_grandfather[:resolved_stem]
    @spouse = build_spouse
    @spouse_stem = @spouse[:resolved_stem]
    @mother_in_law = build_mother_in_law
    @mother_in_law_stem = @mother_in_law[:resolved_stem]
    @father_in_law = build_father_in_law
    @father_in_law_stem = @father_in_law[:resolved_stem]
    @child = build_child
    @child_stem = @child[:resolved_stem]
    @child_spouse = build_child_spouse
    @child_spouse_stem = @child_spouse[:resolved_stem]

    enrich_lineage(user_lineage)
  end

  private

  def build_mother
    build_person(
      :mother,
      origin_stem: original_linage.m_stem,
      target_stem: original_linage.m_stem,
      fallback_stem: year_qi_stem,
      fallback_position_key: :year_qi_stem
    )
  end

  def build_father
    build_person(
      :father,
      origin_stem: original_linage.f_stem,
      target_stem: @mother_stem&.union_stem,
      fallback_stem: year_stem,
      fallback_position_key: :year_stem
    )
  end

  def build_m_grandmother
    build_person(
      :m_grandmother,
      origin_stem: original_linage.m_grandmother_stem,
      target_stem: @mother_stem&.generated_by_stem
    )
  end

  def build_m_grandfather
    return missing_person(:m_grandfather, original_linage.m_grandfather_stem, nil) if @m_grandmother_stem.nil?

    build_person(
      :m_grandfather,
      origin_stem: original_linage.m_grandfather_stem,
      target_stem: @m_grandmother_stem.union_stem
    )
  end

  def build_f_grandmother
    build_person(
      :f_grandmother,
      origin_stem: original_linage.f_grandmother_stem,
      target_stem: @father_stem&.generated_by_stem
    )
  end

  def build_f_grandfather
    return missing_person(:f_grandfather, original_linage.f_grandfather_stem, nil) if @f_grandmother_stem.nil?

    build_person(
      :f_grandfather,
      origin_stem: original_linage.f_grandfather_stem,
      target_stem: @f_grandmother_stem.union_stem
    )
  end

  def build_spouse
    build_person(
      :spouse,
      origin_stem: original_linage.spouse_stem,
      target_stem: day_stem.union_stem,
      fallback_stem: day_qi_stem,
      fallback_position_key: :day_qi_stem
    )
  end

  def build_mother_in_law
    build_person(
      :mother_in_law,
      origin_stem: original_linage.mother_in_law_stem,
      target_stem: @spouse_stem&.generated_by_stem
    )
  end

  def build_father_in_law
    return missing_person(:father_in_law, original_linage.father_in_law_stem, nil) if @mother_in_law_stem.nil?

    build_person(
      :father_in_law,
      origin_stem: original_linage.father_in_law_stem,
      target_stem: @mother_in_law_stem.union_stem
    )
  end

  def build_child
    if gender == 'female'
      build_person(
        :child,
        origin_stem: original_linage.female_child_stem,
        target_stem: original_linage.female_child_stem,
        fallback_stem: month_stem,
        fallback_position_key: :month_stem
      )
    elsif gender == 'male'
      build_person(
        :child,
        origin_stem: original_linage.male_child_stem,
        target_stem: @spouse_stem&.generates_stem,
        fallback_stem: month_stem,
        fallback_position_key: :month_stem
      )
    else
      missing_person(:child, nil, nil)
    end
  end

  def build_child_spouse
    build_person(
      :child_spouse,
      origin_stem: child_spouse_origin_stem,
      target_stem: @child_stem&.union_stem
    )
  end

  def build_siblings
    same_positions = positions_for(day_stem, exclude_keys: [:day_stem])
    yin_yang_stem = day_stem.yin_yang_convert
    yin_yang_positions = positions_for(yin_yang_stem)
    sibling_stems = []
    sibling_stems << day_stem if same_positions.any?
    sibling_stems << yin_yang_stem if yin_yang_positions.any?
    positions = same_positions + yin_yang_positions

    {
      key: :siblings,
      origin_stem: day_stem,
      origin_stem_name: day_stem.name,
      target_stem: day_stem,
      target_stem_name: day_stem.name,
      resolved_stem: sibling_stems.first,
      resolved_stem_name: sibling_stems.map(&:name).join('・').presence,
      resolved_stems: sibling_stems.map { |stem| stem_summary(stem) },
      resolved_stem_ids: sibling_stems.map(&:id),
      text: sibling_stems.map(&:name).presence&.join('・') || '-',
      origin_match_type: positions.any? ? :exact : :missing,
      resolve_type: positions.any? ? :exact : :missing,
      positions: positions,
      fallback_position: nil
    }
  end

  def build_person(role_key, origin_stem:, target_stem:, fallback_stem: nil, fallback_position_key: nil)
    resolution = resolve_stem(target_stem, fallback_stem: fallback_stem, fallback_position_key: fallback_position_key)
    resolved_stem = resolution[:stem]

    {
      key: role_key,
      origin_stem: origin_stem,
      origin_stem_name: origin_stem&.name,
      target_stem: target_stem,
      target_stem_name: target_stem&.name,
      resolved_stem: resolved_stem,
      resolved_stem_name: resolved_stem&.name,
      resolved_stems: [stem_summary(resolved_stem)].compact,
      resolved_stem_ids: [resolved_stem&.id].compact,
      text: "#{origin_stem&.name || '-'}・#{resolved_stem&.name || '-'}",
      origin_match_type: origin_match_type(role_key, origin_stem, resolved_stem, resolution[:resolve_type]),
      resolve_type: resolution[:resolve_type],
      positions: positions_for(resolved_stem),
      fallback_position: position_for_key(fallback_position_key)
    }
  end

  def missing_person(role_key, origin_stem, target_stem)
    {
      key: role_key,
      origin_stem: origin_stem,
      origin_stem_name: origin_stem&.name,
      target_stem: target_stem,
      target_stem_name: target_stem&.name,
      resolved_stem: nil,
      resolved_stem_name: nil,
      resolved_stems: [],
      resolved_stem_ids: [],
      text: "#{origin_stem&.name || '-'}・-",
      origin_match_type: :missing,
      resolve_type: :missing,
      positions: [],
      fallback_position: nil
    }
  end

  def resolve_stem(target_stem, fallback_stem: nil, fallback_position_key: nil)
    if stem_in_chart?(target_stem)
      { stem: target_stem, resolve_type: :exact }
    elsif stem_in_chart?(target_stem&.yin_yang_convert)
      { stem: target_stem.yin_yang_convert, resolve_type: :yin_yang }
    elsif fallback_stem.present?
      { stem: fallback_stem, resolve_type: :place, fallback_position_key: fallback_position_key }
    else
      { stem: nil, resolve_type: :missing }
    end
  end

  def origin_match_type(role_key, origin_stem, resolved_stem, resolve_type)
    return :missing if resolved_stem.nil?
    return :place if resolve_type == :place
    return :exact if origin_stem.present? && resolved_stem.id == origin_stem.id
    return :exact if role_key == :child && origin_stem.present? && resolved_stem.id == origin_stem.yin_yang_convert.id
    return :yin_yang if origin_stem.present? && resolved_stem.id == origin_stem.yin_yang_convert.id

    :other
  end

  def stem_in_chart?(stem)
    stem.present? && @having_stem_ids.include?(stem.id)
  end

  def child_spouse_origin_stem
    if gender == 'female'
      original_linage.female_child_spouse_stem
    elsif gender == 'male'
      original_linage.male_child_spouse_stem
    end
  end

  def user_lineage
    {
      mother: @mother,
      father: @father,
      m_grandmother: @m_grandmother,
      m_grandfather: @m_grandfather,
      f_grandmother: @f_grandmother,
      f_grandfather: @f_grandfather,
      spouse: @spouse,
      mother_in_law: @mother_in_law,
      father_in_law: @father_in_law,
      child: @child,
      child_spouse: @child_spouse,
      siblings: build_siblings
    }
  end

  def enrich_lineage(lineage)
    lineage_roles = LINEAGE_ROLE_KEYS.filter_map { |key| lineage[key] }
    roles_by_stem_id = Hash.new { |hash, key| hash[key] = [] }

    lineage_roles.each do |person|
      person[:resolved_stem_ids].each do |stem_id|
        roles_by_stem_id[stem_id] << person[:key]
      end
    end

    lineage_roles.each do |person|
      shared_roles = person[:resolved_stem_ids].flat_map { |stem_id| roles_by_stem_id[stem_id] }.uniq
      person[:shared_role_keys] = shared_roles - [person[:key]]
      person[:multi_position] = person[:positions].map { |position| position[:group] }.uniq.size > 1
    end

    lineage
  end

  def positions_for(stem, exclude_keys: [])
    return [] unless stem

    natal_stem_positions.select do |position|
      position[:stem_id] == stem.id && !exclude_keys.include?(position[:key])
    end
  end

  def position_for_key(key)
    all_stem_positions.find { |position| position[:key] == key }
  end

  def all_stem_positions
    natal_stem_positions + fallback_stem_positions
  end

  def natal_stem_positions
    @natal_stem_positions ||= [
      stem_position(:day_stem, day_stem, '日干', '自分', '天干', :day_stem),
      stem_position(:month_stem, month_stem, '月干', '子供の場所', '天干', :month_stem),
      stem_position(:year_stem, year_stem, '年干', '父の場所', '天干', :year_stem),
      stem_position(:day_branch_first_stem, day_branch.first_stem, '日支初元', '家庭・座下', '地支', :day_branch),
      stem_position(:day_branch_second_stem, day_branch.second_stem, '日支中元', '家庭・座下', '地支', :day_branch),
      stem_position(:day_branch_third_stem, day_branch.third_stem, '日支本元', '家庭・座下', '地支', :day_branch),
      stem_position(:month_branch_first_stem, month_branch.first_stem, '月支初元', '心・家系', '地支', :month_branch),
      stem_position(:month_branch_second_stem, month_branch.second_stem, '月支中元', '心・家系', '地支', :month_branch),
      stem_position(:month_branch_third_stem, month_branch.third_stem, '月支本元', '心・家系', '地支', :month_branch),
      stem_position(:year_branch_first_stem, year_branch.first_stem, '年支初元', '社会・母の場所', '地支', :year_branch),
      stem_position(:year_branch_second_stem, year_branch.second_stem, '年支中元', '社会・母の場所', '地支', :year_branch),
      stem_position(:year_branch_third_stem, year_branch.third_stem, '年支本元', '社会・母の場所', '地支', :year_branch)
    ].compact.uniq { |position| position[:key] }
  end

  def fallback_stem_positions
    @fallback_stem_positions ||= [
      stem_position(:day_qi_stem, day_qi_stem, '日支主気', '配偶者の場所', '場所', :day_branch),
      stem_position(:year_qi_stem, year_qi_stem, '年支主気', '母の場所', '場所', :year_branch)
    ].compact.uniq { |position| position[:key] }
  end

  def stem_position(key, stem, label, area, layer, group)
    return if stem.blank?

    {
      key: key,
      stem_id: stem.id,
      stem_name: stem.name,
      label: label,
      area: area,
      layer: layer,
      group: group
    }
  end

  def stem_summary(stem)
    return if stem.blank?

    {
      id: stem.id,
      name: stem.name
    }
  end
end
