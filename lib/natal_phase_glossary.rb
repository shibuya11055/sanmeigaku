class NatalPhaseGlossary
  GLOSSARY = YAML.load_file(Rails.root.join('config/natal_phase_glossary.yml')).freeze

  NORMALIZATION_RULES = [
    [/天剋地[冲中]/, '天剋地冲'],
    [/天衝冲/, '天衝冲'],
    [/三合/, '三合会局'],
    [/大半会/, '大半会'],
    [/半会/, '半会'],
    [/支合/, '支合'],
    [/方三位/, '方三位'],
    [/地衝冲|対冲/, '対冲'],
    [/害/, '害'],
    [/自刑/, '自刑'],
    [/生貴刑|旺気刑|庫気刑|刑/, '刑'],
    [/破/, '破'],
    [/律音/, '律音'],
    [/納音/, '納音']
  ].freeze

  def self.lookup(term)
    GLOSSARY[normalize(term)]
  end

  def self.normalize(term)
    term = term.to_s
    NORMALIZATION_RULES.each do |pattern, normalized|
      return normalized if term.match?(pattern)
    end

    term
  end
end
