# == Schema Information
#
# Table name: fortune_analyses
#
#  id                        :bigint           not null, primary key
#  birthday                  :date             not null
#  description               :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  sexagenary_cycle_day_id   :bigint           not null
#  sexagenary_cycle_month_id :bigint           not null
#  sexagenary_cycle_year_id  :bigint           not null
#
# Indexes
#
#  index_fortune_analyses_on_sexagenary_cycle_day_id    (sexagenary_cycle_day_id)
#  index_fortune_analyses_on_sexagenary_cycle_month_id  (sexagenary_cycle_month_id)
#  index_fortune_analyses_on_sexagenary_cycle_year_id   (sexagenary_cycle_year_id)
#
# Foreign Keys
#
#  fk_rails_...  (sexagenary_cycle_day_id => sexagenary_cycles.id)
#  fk_rails_...  (sexagenary_cycle_month_id => sexagenary_cycles.id)
#  fk_rails_...  (sexagenary_cycle_year_id => sexagenary_cycles.id)
#
class FortuneAnalysis < ApplicationRecord
  belongs_to :sexagenary_cycle_year, class_name: "SexagenaryCycle", foreign_key: "sexagenary_cycle_year_id"
  belongs_to :sexagenary_cycle_month, class_name: "SexagenaryCycle", foreign_key: "sexagenary_cycle_month_id"
  belongs_to :sexagenary_cycle_day, class_name: "SexagenaryCycle", foreign_key: "sexagenary_cycle_day_id"
end
