class StemLineageGlossary
  GLOSSARY = YAML.load_file(Rails.root.join('config/stem_lineage_glossary.yml')).freeze

  def self.role(key)
    GLOSSARY.fetch('roles', {})[key.to_s] || {}
  end

  def self.role_label(key)
    role(key)['label'] || key.to_s
  end

  def self.role_priority(key)
    role(key)['priority'] || 'extended'
  end

  def self.match_type(key)
    GLOSSARY.fetch('match_types', {})[key.to_s] || {}
  end

  def self.match_type_label(key)
    match_type(key)['label'] || key.to_s
  end

  def self.resolve_type(key)
    GLOSSARY.fetch('resolve_types', {})[key.to_s] || {}
  end

  def self.resolve_type_label(key)
    resolve_type(key)['label'] || key.to_s
  end

  def self.role_result(role_key, match_type)
    results = GLOSSARY.fetch('role_results', {})
    role_key = role_key.to_s
    match_type = match_type.to_s

    results.dig(role_key, match_type) ||
      results.dig(role_priority(role_key), match_type) ||
      results.dig('default', match_type)
  end

  def self.role_position_result(role_key, match_type, position_group)
    results = GLOSSARY.fetch('role_position_results', {})
    role_key = role_key.to_s
    match_type = match_type.to_s
    position_group = position_group.to_s

    results.dig(role_key, match_type, position_group) ||
      results.dig(role_key, 'default', position_group) ||
      results.dig(role_priority(role_key), match_type, position_group) ||
      results.dig(role_priority(role_key), 'default', position_group) ||
      results.dig('default', position_group)
  end

  def self.shared_result(key)
    GLOSSARY.fetch('shared_results', {})[key.to_s]
  end

  def self.multi_position_result(role_key)
    results = GLOSSARY.fetch('multi_position_results', {})
    role_key = role_key.to_s

    results[role_key] || results[role_priority(role_key)] || results['default']
  end
end
