class AbnormalGlossary
  GLOSSARY = YAML.load_file(Rails.root.join('config/abnormal_glossary.yml')).freeze

  ORDER = %w[甲戌 乙亥 辛巳 壬午 丙戌 丁亥 戊子 癸巳 戊戌 己亥 庚子 辛亥 丁巳].freeze

  def self.lookup(term)
    GLOSSARY[term]
  end

  def self.ordered_terms
    ORDER.map { |term| [term, GLOSSARY[term]] }.select { |_term, entry| entry.present? }
  end
end
