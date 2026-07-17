module Sanmeigaku
  class NatalChartCalculator
    MIN_DATE = Date.new(1925, 1, 1)
    MAX_DATE = Date.new(2044, 12, 31)
    UNSUPPORTED_ANALYSIS_MESSAGE = 'この日付は前後の月入日データがないため、詳細な命式を計算できません。対応範囲をご確認ください。'

    attr_reader :birth_date

    def initialize(birth_date)
      @birth_date = birth_date.to_date
    end

    def self.call(birth_date:)
      new(birth_date).calculate
    end

    def self.analysis_supported?(birth_date:, gender:)
      new(birth_date).analysis_supported?(gender)
    rescue ArgumentError, TypeError
      false
    end

    def calculate
      validate_date!

      year_num = build_year_num
      month_num = build_month_num
      day_num = build_day_num

      StaticData::Result.new(
        birth_date,
        StaticData.cycle(year_num),
        StaticData.cycle(month_num),
        StaticData.cycle(day_num)
      )
    end

    def analysis_supported?(gender)
      return false unless birth_date.between?(MIN_DATE, MAX_DATE)

      current_entry = LunarCalendarEntry.find_by(year: birth_date.year)
      return false unless current_entry
      return false if birth_date.month == 1 && LunarCalendarEntry.find_by(year: birth_date.year - 1).nil?

      next_year_required = birth_date.month == 12 && birth_date.day >= current_entry.entries[11]
      return true unless next_year_required && forward_sequence?(gender)

      LunarCalendarEntry.find_by(year: birth_date.year + 1).present?
    end

    private

    def validate_date!
      return if birth_date.between?(MIN_DATE, MAX_DATE)

      raise ArgumentError, "対応範囲外の日付です: #{MIN_DATE}〜#{MAX_DATE}"
    end

    def build_year_num
      year_num = (birth_date.year - 1900 + 37) % 60
      year_num = 60 if year_num.zero?
      year_num -= 1 unless LunarCalendarEntry.current_year?(birth_date)
      year_num = 60 if year_num.zero?
      year_num
    end

    def build_month_num
      month_num = ((birth_date.year - 1900) * 12 + 14) % 60
      month_num = 60 if month_num.zero?
      month_num += birth_date.month - 1
      month_num -= 1 if LunarCalendarEntry.lunar_birth_day(birth_date) > birth_date.day
      month_num = 1 if month_num > 60
      month_num
    end

    def build_day_num
      day_num = YearlyDayNumber.day_number(birth_date) + birth_date.day - 1
      day_num -= 60 while day_num > 60
      day_num
    end

    def forward_sequence?(gender)
      year_stem = StaticData.cycle(build_year_num).stem
      is_yin = year_stem.yin_yang == '陰'

      if gender.to_s == 'male'
        !is_yin
      else
        is_yin
      end
    end
  end
end
