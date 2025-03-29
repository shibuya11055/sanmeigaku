class TenStarDirection
  MESSAGES = YAML.load_file(Rails.root.join("config/ten_star_direction.yml")).freeze

  def get_message(key)
    keys = key.split(".")
    MESSAGES.dig(*keys) || "キーが見つかりません"
  end
end
