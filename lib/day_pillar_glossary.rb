class DayPillarGlossary
  GLOSSARY = YAML.load_file(Rails.root.join('config/day_pillar_glossary.yml')).freeze

  def self.lookup(value)
    GLOSSARY[pillar_name(value)]
  end

  def self.meta(entry)
    values = ["日番号#{entry['number']}", entry['void'], entry['sub_star'], entry['special']]
    values.compact.join(' / ')
  end

  def self.pillar_name(value)
    return value.stem_and_branch if value.respond_to?(:stem_and_branch)

    value.to_s
  end
end
