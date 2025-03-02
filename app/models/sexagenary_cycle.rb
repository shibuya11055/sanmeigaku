class SexagenaryCycle < ApplicationRecord
  belongs_to :stem
  belongs_to :branch
  has_many :fortune_analysis_years, class_name: "FortuneAnalysis", foreign_key: "sexagenary_cycle_year_id"
  has_many :fortune_analysis_months, class_name: "FortuneAnalysis", foreign_key: "sexagenary_cycle_month_id"
  has_many :fortune_analysis_days, class_name: "FortuneAnalysis", foreign_key: "sexagenary_cycle_day_id"

  enum :heavenly_void, {
    '戊亥天中殺': 0,
    '申酉天中殺': 1,
    '午未天中殺': 2,
    '辰巳天中殺': 3,
    '寅卯天中殺': 4,
    '子丑天中殺': 5
  }

  def stem_and_branch
    "#{stem.name}#{branch.name}"
  end
end
