class FortuneSubStarGlossary
  GLOSSARY = YAML.load_file(Rails.root.join('config/fortune_sub_star_glossary.yml')).freeze

  def self.lookup(term)
    GLOSSARY[term]
  end
end
