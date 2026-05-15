class TwelveSubStarGlossary
  GLOSSARY = YAML.load_file(Rails.root.join('config/twelve_sub_star_glossary.yml')).freeze

  PERIODS = {
    'youth' => '若年期',
    'middle' => '中年期',
    'old' => '晩年期'
  }.freeze

  def self.lookup(term)
    GLOSSARY[term]
  end

  def self.period_label(period)
    PERIODS[period]
  end
end
