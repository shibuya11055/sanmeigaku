class BeastTypeGlossary
  GLOSSARY = YAML.load_file(Rails.root.join('config/beast_type_glossary.yml')).freeze

  TYPE_PATTERN = /(?<type>騰陀|朱雀|青龍|白虎|玄武)/
  YIN_YANG_PATTERN = /（(?<yin_yang>陽型|陰型)）/

  def self.lookup(beast_type)
    type_name = normalize_type(beast_type)
    return nil unless type_name

    GLOSSARY[type_name]
  end

  def self.normalize_type(beast_type)
    beast_type.to_s.match(TYPE_PATTERN)&.[](:type)
  end

  def self.yin_yang_label(beast_type)
    beast_type.to_s.match(YIN_YANG_PATTERN)&.[](:yin_yang)
  end

  def self.yin_yang_detail(beast_type)
    case yin_yang_label(beast_type)
    when '陽型'
      GLOSSARY.dig('陰陽分類', 'yang')
    when '陰型'
      GLOSSARY.dig('陰陽分類', 'yin')
    end
  end
end
