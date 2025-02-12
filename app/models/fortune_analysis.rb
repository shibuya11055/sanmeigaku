class FortuneAnalysis < ApplicationRecord
  belongs_to :sexagenary_cycle_year, class_name: "SexagenaryCycle", foreign_key: "sexagenary_cycle_year_id"
  belongs_to :sexagenary_cycle_month, class_name: "SexagenaryCycle", foreign_key: "sexagenary_cycle_month_id"
  belongs_to :sexagenary_cycle_day, class_name: "SexagenaryCycle", foreign_key: "sexagenary_cycle_day_id"
end
