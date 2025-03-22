class StemLineageCalculator
  attr_reader :original_linage, 
              :day_stem, 
              :month_stem, 
              :year_stem, 
              :day_branch, 
              :month_branch, 
              :year_branch, 
              :year_qi_stem,
              :day_qi_stem

  def initialize(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, year_qi_stem, day_qi_stem)
    @day_stem = day_stem
    @month_stem = month_stem
    @year_stem = year_stem
    @day_branch = day_branch
    @month_branch = month_branch
    @year_branch = year_branch
    @year_qi_stem = year_qi_stem
    @day_qi_stem = day_qi_stem
    @original_linage = StemLineage.eager_load_all_stems.find_by(day_stem: day_stem)
  end

  def self.call(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, year_qi_stem, day_qi_stem)
    new(day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, year_qi_stem, day_qi_stem).calculate
  end

  def calculate
    @having_stem_ids = having_stem_ids

    @mother_stem = build_mother_stem
    @father_stem = build_father_stem
    @m_grandmother_stem = build_m_grandmother_stem
    @m_grandfather_stem = build_m_grandfather_stem
    @f_grandmother_stem = build_f_grandmother_stem
    @f_grandfather_stem = build_f_grandfather_stem
    @spouse_stem = build_spouse_stem
    @mother_in_law_stem = build_mother_in_law_stem
    @father_in_law_stem = build_father_in_law_stem
    @child_stem = build_child_stem
    @child_spouse_stem = build_child_spouse_stem

    user_lineage
  end

  private

  def having_stem_ids
    ids = [
      day_stem.id,
      month_stem.id,
      year_stem.id,
      day_branch.first_stem_id,
      day_branch.second_stem_id,
      day_branch.third_stem_id,
      month_branch.first_stem_id,
      month_branch.second_stem_id,
      month_branch.third_stem_id,
      year_branch.first_stem_id,
      year_branch.second_stem_id,
      year_branch.third_stem_id,
    ].compact

    ids
  end

  def build_mother_stem
    m_stem_origin = original_linage.m_stem
    m_stem_convert = m_stem_origin.yin_yang_convert

    if @having_stem_ids.include?(m_stem_origin.id)
      m_stem_origin
    elsif @having_stem_ids.include?(m_stem_convert.id)
      m_stem_convert
    else
      year_qi_stem
    end
  end

  def build_father_stem
    union_stem_mother = @mother_stem.union_stem
    union_stem_mother_convert = union_stem_mother.yin_yang_convert

    if @having_stem_ids.include?(union_stem_mother.id)
      union_stem_mother
    elsif @having_stem_ids.include?(union_stem_mother_convert.id)
      union_stem_mother_convert
    else
      year_stem
    end
  end

  def build_m_grandmother_stem
    m_grandmother_stem_origin = original_linage.m_grandmother_stem
    m_grandmother_stem_origin_convert = m_grandmother_stem_origin.yin_yang_convert

    if @having_stem_ids.include?(m_grandmother_stem_origin.id)
      m_grandmother_stem_origin
    elsif @having_stem_ids.include?(m_grandmother_stem_origin_convert.id)
      m_grandmother_stem_origin_convert
    else
      nil
    end
  end

  def build_m_grandfather_stem
    if @m_grandmother_stem.nil?
      return nil
    end

    union_stem_m_grandmother = @m_grandmother_stem.union_stem
    union_stem_m_grandmother_convert = union_stem_m_grandmother.yin_yang_convert

    if @having_stem_ids.include?(union_stem_m_grandmother.id)
      union_stem_m_grandmother
    elsif @having_stem_ids.include?(union_stem_m_grandmother_convert.id)
      union_stem_m_grandmother_convert
    else
      nil
    end
  end

  def build_f_grandmother_stem
    f_grandmother_stem_origin = original_linage.f_grandmother_stem
    f_grandmother_stem_origin_convert = f_grandmother_stem_origin.yin_yang_convert

    if @having_stem_ids.include?(f_grandmother_stem_origin.id)
      f_grandmother_stem_origin
    elsif @having_stem_ids.include?(f_grandmother_stem_origin_convert.id)
      f_grandmother_stem_origin_convert
    else
      nil
    end
  end

  def build_f_grandfather_stem
    if @f_grandmother_stem.nil?
      return nil
    end

    union_stem_f_grandmother = @f_grandmother_stem.union_stem
    union_stem_f_grandmother_convert = union_stem_f_grandmother.yin_yang_convert

    if @having_stem_ids.include?(union_stem_f_grandmother.id)
      union_stem_f_grandmother
    elsif @having_stem_ids.include?(union_stem_f_grandmother_convert.id)
      union_stem_f_grandmother_convert
    else
      nil
    end
  end

  def build_spouse_stem
    union_stem = day_stem.union_stem
    union_stem_convert = union_stem.yin_yang_convert

    if @having_stem_ids.include?(union_stem.id)
      union_stem
    elsif @having_stem_ids.include?(union_stem_convert.id)
      union_stem_convert
    else
      day_qi_stem
    end
  end

  def build_mother_in_law_stem
    generated_stem = @spouse_stem.generated_by_stem
    generated_stem_convert = generated_stem.yin_yang_convert

    if @having_stem_ids.include?(generated_stem.id)
      generated_stem
    elsif @having_stem_ids.include?(generated_stem_convert.id)
      generated_stem_convert
    else
      nil
    end
  end

  def build_father_in_law_stem
    if @mother_in_law_stem.nil?
      return nil
    end
    
    union_stem_mother_in_law = @mother_in_law_stem.union_stem
    union_stem_mother_in_law_convert = union_stem_mother_in_law.yin_yang_convert

    if @having_stem_ids.include?(union_stem_mother_in_law.id)
      union_stem_mother_in_law
    elsif @having_stem_ids.include?(union_stem_mother_in_law_convert.id)
      union_stem_mother_in_law_convert
    else
      nil
    end
  end

  def build_child_stem
    if day_stem.yin_yang == '陰'
      female_child_stem = original_linage.female_child_stem
      female_child_stem_convert = female_child_stem.yin_yang_convert

      if @having_stem_ids.include?(female_child_stem.id)
        female_child_stem
      elsif @having_stem_ids.include?(female_child_stem_convert.id)
        female_child_stem_convert
      else
        month_stem
      end
    else
      male_child_stem = @spouse_stem.generates_stem
      male_child_stem_convert = male_child_stem.yin_yang_convert

      if @having_stem_ids.include?(male_child_stem.id)
        male_child_stem
      elsif @having_stem_ids.include?(male_child_stem_convert.id)
        male_child_stem_convert
      else
        month_stem
      end
    end
  end

  def build_child_spouse_stem
    child_spouse_stem = @child_stem.union_stem
    child_spouse_stem_convert = child_spouse_stem.yin_yang_convert

    if @having_stem_ids.include?(child_spouse_stem.id)
      child_spouse_stem
    elsif @having_stem_ids.include?(child_spouse_stem_convert.id)
      child_spouse_stem_convert
    else
      nil
    end
  end

  def user_lineage
    is_female_day_stem = day_stem.yin_yang == '陰'
    child_text = nil
    child_spouse_text = nil

    if is_female_day_stem
      child_text = "#{original_linage.female_child_stem.name}・#{@child_stem.name}"
      child_spouse_text = "#{original_linage.female_child_spouse_stem.name || '-'}・#{@child_spouse_stem&.name}"
    else
      child_text = "#{original_linage.male_child_stem.name}・#{@child_stem.name}"
      child_spouse_text = "#{original_linage.male_child_spouse_stem&.name || '-'}・#{@child_spouse_stem.name}"
    end

    {
      mother: {
        text: "#{original_linage.m_stem.name}・#{@mother_stem&.name}",
      },
      father: {
        text: "#{original_linage.f_stem.name}・#{@father_stem&.name}",
      },
      m_grandmother: {
        text: "#{original_linage.m_grandmother_stem&.name}・#{@m_grandmother_stem&.name || '-'}",
      },
      m_grandfather: {
        text: "#{original_linage.m_grandfather_stem.name}・#{@m_grandfather_stem&.name || '-'}",
      },
      f_grandmother: {
        text: "#{original_linage.f_grandmother_stem.name}・#{@f_grandmother_stem&.name || '-'}",
      },
      f_grandfather: {
        text: "#{original_linage.f_grandfather_stem.name}・#{@f_grandfather_stem&.name || '-'}",
      },
      spouse: {
        text: "#{original_linage.spouse_stem.name}・#{@spouse_stem&.name}",
      },
      mother_in_law: {
        text: "#{original_linage.mother_in_law_stem.name}・#{@mother_in_law_stem&.name || '-'}",
      },
      father_in_law: {
        text: "#{original_linage.father_in_law_stem.name}・#{@father_in_law_stem&.name || '-'}",
      },
      child: {
        text: child_text,
      },
      child_spouse: {
        text: child_spouse_text,
      },
    }
  end
end
