class SexagenaryCycle < ApplicationRecord
  belongs_to :stem
  belongs_to :branch
  has_many :fortune_analysis_years, class_name: "FortuneAnalysis", foreign_key: "sexagenary_cycle_year_id"
  has_many :fortune_analysis_months, class_name: "FortuneAnalysis", foreign_key: "sexagenary_cycle_month_id"
  has_many :fortune_analysis_days, class_name: "FortuneAnalysis", foreign_key: "sexagenary_cycle_day_id"
end
