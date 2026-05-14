class RelationshipGlossary
  GLOSSARY = YAML.load_file(Rails.root.join('config/relationship_glossary.yml')).freeze

  # 用語カテゴリ → ラベル / 表示色クラス
  CATEGORIES = {
    'good' => { label: '好相性', css: 'rel-good' },
    'good_strong' => { label: '好相性（強）', css: 'rel-good-strong' },
    'special' => { label: '特殊', css: 'rel-special' },
    'caution' => { label: '注意', css: 'rel-caution' },
    'bad' => { label: '凶', css: 'rel-bad' },
    'bad_strong' => { label: '大凶', css: 'rel-bad-strong' }
  }.freeze

  # 凡例表示順
  ORDER = %w[干合 半会 大半会 支合 方三位 冲 害 刑 破 天剋地冲 律音 納音 同 自刑 支合破 冲刑 刑破 害刑 合刑破].freeze

  def self.lookup(term)
    GLOSSARY[term]
  end

  def self.category_css(term)
    entry = GLOSSARY[term]
    return nil unless entry
    CATEGORIES[entry['category']][:css]
  end

  def self.category_label(term)
    entry = GLOSSARY[term]
    return nil unless entry
    CATEGORIES[entry['category']][:label]
  end

  # 凡例で順番に並べるためのリスト
  def self.ordered_terms
    ORDER.map { |term| [term, GLOSSARY[term]] }.select { |_term, entry| entry.present? }
  end
end
