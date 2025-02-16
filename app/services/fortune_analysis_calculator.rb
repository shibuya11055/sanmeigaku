class FortuneAnalysisCalculator
  attr_reader :birth_date, :year, :month, :day

  def initialize(birth_date)
    @birth_date = birth_date
    @year = @birth_date.year
    @month = @birth_date.month
    @day = @birth_date.day
  end

  def self.call(birth_date)
    new(birth_date).calculate
  end

  def calculate
    year_num = build_year_num
    month_num = build_month_num
    day_num = build_day_num

    create_fortune_analysis(year_num, month_num, day_num)
  end

  private

  # 年番号算出
  def build_year_num
    year_num = (year - 1900 + 37) % 60
    # この時点で余りがなければ60を返す
    return 60 if year_num.zero?
    # 生まれ年が去年の場合は1年引く
    year_num -= 1 if !LunarCalendarEntry.current_year?(birth_date)
    # 0の場合は60を返す
    year_num = 60 if year_num.zero?
    year_num
  end

  # 月番号算出
  def build_month_num
    month_num = ((year - 1900) * 12 + 14) % 60
    return  60 if month_num.zero?

    month_num = month_num + (month - 1)
    month_num = month_num - 1 if LunarCalendarEntry.lunar_birth_day(birth_date) > day
    month_num = 1 if month_num > 60
    month_num
  end

  # 日番号算出
  def build_day_num
    entry_day = YearlyDayNumber.day_number(birth_date)
    day_num = entry_day + day - 1
    day_num = day_num - 60 if day_num > 60
    day_num
  end

  def create_fortune_analysis(year_num, month_num, day_num)
    FortuneAnalysis.create!(
      birthday: birth_date,
      sexagenary_cycle_year_id: year_num,
      sexagenary_cycle_month_id: month_num,
      sexagenary_cycle_day_id: day_num
    )
  end
end