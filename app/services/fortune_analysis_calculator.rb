class FortuneAnalysisCalculator
  attr_reader :birth_date, :year, :month, :day

  def initialize(birth_date)
    @birth_date = birth_date.to_date
    @year = @birth_date.year
    @month = @birth_date.month
    @day = @birth_date.day
    @chart_calculator = Sanmeigaku::NatalChartCalculator.new(@birth_date)
  end

  def self.call(birth_date)
    new(birth_date).calculate
  end

  def calculate
    chart = calculate_chart

    create_fortune_analysis(
      chart.sexagenary_cycle_year_id,
      chart.sexagenary_cycle_month_id,
      chart.sexagenary_cycle_day_id
    )
  end

  # 命式の算出そのものは静的マスタだけで行う。DB保存が必要なseed等は calculate を使う。
  def calculate_chart
    @chart_calculator.calculate
  end

  private

  # 年番号算出
  def build_year_num
    calculate_chart.sexagenary_cycle_year_id
  end

  # 月番号算出
  def build_month_num
    calculate_chart.sexagenary_cycle_month_id
  end

  # 日番号算出
  def build_day_num
    calculate_chart.sexagenary_cycle_day_id
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
