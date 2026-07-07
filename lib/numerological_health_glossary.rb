class NumerologicalHealthGlossary
  GLOSSARY = YAML.load_file(Rails.root.join('config/numerological_health_glossary.yml')).freeze
  ELEMENT_ORDER = %w[木 火 土 金 水].freeze
  CONTROLLED_BY = {
    '木' => '金',
    '火' => '水',
    '土' => '木',
    '金' => '火',
    '水' => '土'
  }.freeze

  def self.element(element_name)
    GLOSSARY.dig('elements', normalize_element(element_name))
  end

  def self.dominant_branch_reading(element_name, branch_name)
    element_groups = GLOSSARY.dig('dominant_branch_groups', normalize_element(element_name)) || {}
    branch = branch_name.to_s
    _, reading = element_groups.find { |branches, _text| branches.include?(branch) }

    reading
  end

  def self.dominant_branch_detail(element_name, branch_name)
    GLOSSARY.dig('dominant_branch_details', normalize_element(element_name), branch_name.to_s)
  end

  def self.harm_pair(first_branch_name, second_branch_name)
    first = first_branch_name.to_s
    second = second_branch_name.to_s
    key = GLOSSARY['harm_pairs'].key?("#{first}#{second}") ? "#{first}#{second}" : "#{second}#{first}"

    GLOSSARY.dig('harm_pairs', key)
  end

  def self.season_for_branch(branch_name)
    branch = branch_name.to_s
    season_bias_entries.find { |_season, entry| entry['branches'].include?(branch) }&.first
  end

  def self.season_bias(season)
    GLOSSARY.dig('season_bias', season.to_s)
  end

  def self.season_bias_entries
    GLOSSARY['season_bias'] || {}
  end

  def self.controlled_by(element_name)
    CONTROLLED_BY[normalize_element(element_name)]
  end

  def self.normalize_element(element_name)
    element_name.to_s.delete_suffix('性')
  end
end
