class HeavenlyVoidWaveCalculator
  # 「あなたの今後」として表示する年数（１サイクル分）
  TIMELINE_YEARS = 12

  # 60干支ID のグループ範囲（教材：1〜10は戌亥、11〜20は申酉...）
  CYCLE_GROUP_RANGES = [
    { range: 1..10, void: '戌亥' },
    { range: 11..20, void: '申酉' },
    { range: 21..30, void: '午未' },
    { range: 31..40, void: '辰巳' },
    { range: 41..50, void: '寅卯' },
    { range: 51..60, void: '子丑' }
  ].freeze

  attr_reader :birthday, :day_stem, :day_branch, :day_heavenly_void, :sexagenary_cycle_day, :today

  def initialize(birthday, day_stem, day_branch, day_heavenly_void, sexagenary_cycle_day, today: Date.today)
    @birthday = birthday
    @day_stem = day_stem
    @day_branch = day_branch
    @day_heavenly_void = day_heavenly_void
    @sexagenary_cycle_day = sexagenary_cycle_day
    @today = today
  end

  def self.call(birthday, day_stem, day_branch, day_heavenly_void, sexagenary_cycle_day, today: Date.today)
    new(birthday, day_stem, day_branch, day_heavenly_void, sexagenary_cycle_day, today: today).calculate
  end

  def calculate
    pattern = HeavenlyVoidWavePattern.find_by_void(void_key)
    return nil unless pattern

    start_year = eto_year(today)
    end_year = start_year + TIMELINE_YEARS - 1

    {
      heavenly_void: void_key,
      full_name: pattern.full_name,
      summary: pattern.summary,
      reasoning: build_reasoning,
      reference_table: build_reference_table(pattern),
      personal_timeline: build_personal_timeline(pattern, start_year),
      start_year: start_year,
      end_year: end_year,
      phase_legend: pattern.phase_legend
    }
  end

  private

  def void_key
    # enum の値は "戌亥" だが、念のため "天中殺" の語が混入してもよいよう除去
    day_heavenly_void.to_s.gsub('天中殺', '')
  end

  # 干支歴の年（節分=立春前は前年扱い）。立春は LunarCalendarEntry の2月の月入日
  def eto_year(date)
    feb_entry = LunarCalendarEntry.find_by(year: date.year)
    return date.year - 1 unless feb_entry

    risshu_day = feb_entry.entries[1]
    if date.month < 2 || (date.month == 2 && date.day < risshu_day)
      date.year - 1
    else
      date.year
    end
  end

  # 学習用：なぜこの天中殺になるのか
  def build_reasoning
    cycle_id = sexagenary_cycle_day.id
    group = CYCLE_GROUP_RANGES.find { |g| g[:range].cover?(cycle_id) }
    range_label = group ? "#{group[:range].first}〜#{group[:range].last}番グループ" : '不明'
    {
      day_pillar: "#{day_stem.name}#{day_branch.name}",
      cycle_id: cycle_id,
      group_range: range_label,
      result: "#{void_key}天中殺",
      steps: [
        "日柱の60干支は #{day_stem.name}#{day_branch.name}（ID: #{cycle_id}番）",
        "ID #{cycle_id} は #{range_label}に属する",
        "このグループに対応する天中殺は #{void_key}天中殺",
        "したがって、あなたの波動パターンは「#{void_key}天中殺の波動」"
      ]
    }
  end

  # 12支固定順の参考表（教材通りの並び）
  def build_reference_table(pattern)
    HeavenlyVoidWavePattern::BRANCH_ORDER.map do |branch_name|
      entry = pattern.entry_for(branch_name)
      {
        branch: branch_name,
        month: entry[:month],
        phase: entry[:phase],
        description: entry[:description],
        tone: HeavenlyVoidWavePattern::PHASE_TONES[entry[:phase]],
        is_void: entry[:phase] == '天中殺'
      }
    end
  end

  # 個人タイムライン：今年（干支歴）から TIMELINE_YEARS 年分の波動
  def build_personal_timeline(pattern, start_year)
    yearly_data = CalendarDetail.yearly_stem_and_branch
    birthday_eto_year = eto_year(birthday)

    (start_year...(start_year + TIMELINE_YEARS)).map do |year|
      year_data = yearly_data.find { |yd| yd[:year] == year }
      next nil unless year_data

      branch_name = year_data[:branch]
      entry = pattern.entry_for(branch_name)
      next nil unless entry

      {
        year: year,
        age: year - birthday_eto_year,
        branch: branch_name,
        stem_and_branch: year_data[:stem_and_branch],
        phase: entry[:phase],
        description: entry[:description],
        tone: HeavenlyVoidWavePattern::PHASE_TONES[entry[:phase]],
        is_void: entry[:phase] == '天中殺',
        is_current_year: year == start_year
      }
    end.compact
  end
end
