class FortuneRelationshipGlossary
  GLOSSARY = YAML.load_file(Rails.root.join('config/fortune_relationship_glossary.yml')).freeze

  POSITION_LABELS = {
    day: '日支（家庭・結果・私生活）',
    month: '月支（心の状態）',
    year: '年支（仕事・社会・学校）'
  }.freeze

  DEFAULT_POSITION_TEXT = {
    day: '家庭・結果・私生活では環境の影響が自然に出やすく、日常の積み重ねがそのまま表れます。',
    month: '心の状態は大きく乱れにくく、考え方や気持ちを普段どおり扱いやすい年です。',
    year: '仕事・社会・学校では実力がそのまま出やすく、外側の環境は自然に動きます。'
  }.freeze

  def self.lookup(term)
    GLOSSARY[term]
  end

  def self.position_entry(term, position)
    lookup(term)&.dig('positions', position.to_s)
  end

  def self.position_label(position)
    POSITION_LABELS[position]
  end

  def self.default_position_text(position)
    DEFAULT_POSITION_TEXT[position]
  end
end
