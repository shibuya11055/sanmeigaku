class FortuneMajorStarGlossary
  GLOSSARY = YAML.load_file(Rails.root.join('config/fortune_major_star_glossary.yml')).freeze

  def self.lookup(term)
    GLOSSARY[term]
  end
end
