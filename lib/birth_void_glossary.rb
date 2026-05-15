class BirthVoidGlossary
  GLOSSARY = YAML.load_file(Rails.root.join('config/birth_void_glossary.yml')).freeze

  GROUPED_KEYS = {
    birth_year_void: '生年中殺',
    birth_month_void: '生月中殺'
  }.freeze

  DIRECT_KEYS = {
    birth_day_void: '生日中殺',
    day_position_void: '日座天中殺',
    day_residence_void: '日居天中殺',
    double_birth_void: '宿命二中殺'
  }.freeze

  def self.lookup(key, heavenly_void)
    glossary_key = glossary_key(key, heavenly_void)
    GLOSSARY[glossary_key] || GLOSSARY[DIRECT_KEYS[key.to_sym]] || GLOSSARY[GROUPED_KEYS[key.to_sym]]
  end

  def self.lookup_term(term)
    GLOSSARY[term]
  end

  def self.glossary_key(key, heavenly_void)
    grouped_key = GROUPED_KEYS[key.to_sym]
    return DIRECT_KEYS[key.to_sym] unless grouped_key

    "#{heavenly_void}#{grouped_key}"
  end
end
