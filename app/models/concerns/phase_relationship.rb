module PhaseRelationship
  extend ActiveSupport::Concern

  # 三合
  # 半会はこのうちの二つ
  TRINE_IDS = {
    water: [9, 1, 5],
    wood: [8, 4, 12],
    fire: [3, 7, 11],
    metal: [2, 6, 10]
  }

  # 支合
  COMBINATION_IDS = {
    north: [1, 2],
    east: [3, 12],
    west: [6, 9],
    south: [7, 8],
    Heavenly: [5, 10],
    center: [11, 4]
  }

  # 方三位
  # 準方三位はこのうち二つ
  DIRECTIONAL_IDS = {
    winter: [12, 1, 2],
    spring: [3, 4, 5],
    summer: [6, 7, 8],
    autumn: [9, 10, 11]
  }

  # 対冲
  CLASH_IDS = {
    Heavenly: [[3, 9], [12, 6], [5, 11]],
    earthly: [[1, 7], [2, 8], [4, 10]]
  }

  # 害
  HARM_IDS = [[1, 8], [3, 6], [2, 7], [9, 12], [4, 5], [10, 11]]

  # 刑
  PUNISHMENT_IDS = {
    noble: [3, 6, 9],
    prosperous: [1, 4],
    hidden: [2, 8, 11],
    self_punishment: {
      noble: [12],
      prosperous: [7, 10],
      hidden: [5]
    }
  }

  # 破
  BRAKE_IDS = [[2, 5], [4, 7], [11, 8], [1, 10], [9, 6], [12, 3]]
end
