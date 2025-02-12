class SexagenaryCycle < ApplicationRecord
  belongs_to :heavenly_stem
  belongs_to :earthly_branch
  has_many :user_fortune_analysis_years, class_name: "UserFortuneAnalysis", foreign_key: "sexagenary_cycle_year_id"
  has_many :user_fortune_analysis_months, class_name: "UserFortuneAnalysis", foreign_key: "sexagenary_cycle_month_id"
  has_many :user_fortune_analysis_days, class_name: "UserFortuneAnalysis", foreign_key: "sexagenary_cycle_day_id"
end
