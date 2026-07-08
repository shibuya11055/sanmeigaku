class NumerologicalStructureGlossary
  GLOSSARY = YAML.load_file(Rails.root.join('config/numerological_structure_glossary.yml')).freeze

  def self.lookup(key)
    GLOSSARY[key.to_s]
  end
end
