class RelationshipCalculator
  attr_reader :stem_name,
              :branch_name,
              :sub_stem_name,
              :sub_branch_name

  def initialize(stem_name, branch_name, sub_stem_name, sub_branch_name)
    @stem_name = stem_name
    @branch_name = branch_name
    @sub_stem_name = sub_stem_name
    @sub_branch_name = sub_branch_name
  end

  def self.call(stem_name, branch_name, sub_stem_name, sub_branch_name)
    new(stem_name, branch_name, sub_stem_name, sub_branch_name).calculate
  end

  def calculate
    strong_half_trine = nil
    nacchin = nil
    dual_clash = nil

    # 位相
    relationship = Branch::RELATIONSHIPS_HASH[branch_name.to_sym][sub_branch_name.to_sym]
    # 干合
    union = Stem::UNION_NAMES.include?(stem_name + sub_stem_name) ? '干合' : nil
    # 律音
    ricchin = stem_name == sub_stem_name && branch_name == sub_branch_name ? '律音' : nil

    if relationship.present?
      # 大半会
      if relationship == '半会' && stem_name == sub_stem_name
        strong_half_trine = '大半会'
        relationship = relationship.gsub('半会', '')
      end


      if relationship.include?('冲')
        # 納音
        nacchin = relationship.include?('冲') && stem_name == sub_stem_name ? '納音' : nil

        if nacchin.nil?
          # 天剋地冲（干の陰陽が同じ、かつ相剋の関係）
          yin_yang = StemDefinition.find_by(name: stem_name).yin_yang
          year_stem_yin_yang = StemDefinition.find_by(name: sub_stem_name).yin_yang
          dual_clash = Stem::STEM_CONFLICTS.include?(stem_name + sub_stem_name) && yin_yang == year_stem_yin_yang ? '天剋地冲' : nil
        end

        if nacchin.present? || dual_clash.present?
          relationship = relationship.gsub('冲', '')
        end
      end
    end

    # nilの文字列の変数以外を\nで連結
    [relationship, union, strong_half_trine, ricchin, nacchin, dual_clash].compact.join("\n")
  end
end
