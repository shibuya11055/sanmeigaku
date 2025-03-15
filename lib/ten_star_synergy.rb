class TenStarSynergy
  MESSAGES = YAML.load_file(Rails.root.join("config/ten_star_synergy.yml")).freeze

  def get_message(key)
    keys = key.split(".")
    MESSAGES.dig(*keys) || "キーが見つかりません"
  end
end