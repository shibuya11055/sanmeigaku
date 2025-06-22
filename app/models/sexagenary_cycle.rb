# == Schema Information
#
# Table name: sexagenary_cycles
#
#  id                                                                                                      :integer          not null, primary key
#  heavenly_void(0: 戌亥天中殺, 1: 申酉天中殺, 2: 午未天中殺, 3: 辰已天中殺, 4: 寅卯天中殺, 5: 子丑天中殺) :integer          not null
#  name                                                                                                    :string           not null
#  created_at                                                                                              :datetime         not null
#  updated_at                                                                                              :datetime         not null
#  branch_id                                                                                               :bigint           not null
#  stem_id                                                                                                 :bigint           not null
#
# Indexes
#
#  index_sexagenary_cycles_on_branch_id  (branch_id)
#  index_sexagenary_cycles_on_stem_id    (stem_id)
#
# Foreign Keys
#
#  fk_rails_...  (branch_id => branches.id)
#  fk_rails_...  (stem_id => stems.id)
#
class SexagenaryCycle < ApplicationRecord
  ABNORMAL_MAPPING_IDS = [11, 12, 35, 37, 48, 54, 18, 19, 24, 23, 25, 30, 36]
  DAY_POSITION_VOID_IDS = [11, 12]
  DAY_RESIDENCE_VOID_IDS = [41, 42]
  MAX_NUMBER = 60

  belongs_to :stem
  belongs_to :branch
  has_many :fortune_analysis_years, class_name: "FortuneAnalysis", foreign_key: "sexagenary_cycle_year_id"
  has_many :fortune_analysis_months, class_name: "FortuneAnalysis", foreign_key: "sexagenary_cycle_month_id"
  has_many :fortune_analysis_days, class_name: "FortuneAnalysis", foreign_key: "sexagenary_cycle_day_id"

  # 天中殺
  enum :heavenly_void, {
    '戌亥': 0,
    '申酉': 1,
    '午未': 2,
    '辰巳': 3,
    '寅卯': 4,
    '子丑': 5
  }

  def stem_and_branch
    "#{stem.name}#{branch.name}"
  end

  def abnormal?
    ABNORMAL_MAPPING_IDS.include?(id)
  end

  def abnormal_stem_and_branch_name
    if self.abnormal?
      return stem.name + branch.name
    else
      nil
    end
  end

  # 日座天中殺かどうか
  def day_position_void?
    DAY_POSITION_VOID_IDS.include?(id)
  end

  # 日居天中殺かどうか
  def day_residence_void?
    DAY_RESIDENCE_VOID_IDS.include?(id)
  end
end
