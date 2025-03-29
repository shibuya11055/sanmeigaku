class PhaseMethodText
  MESSAGES = YAML.load_file(Rails.root.join('config/phase_method.yml')).freeze

  def get_message(key)
    keys = key.split('.')
    MESSAGES.dig(*keys) || 'キーが見つかりません'
  end
end
