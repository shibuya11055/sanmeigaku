class MajorFortuneCalculator
  attr_reader :date,
              :result,
              :gender,
              :day_stem,
              :month_stem,
              :year_stem,
              :day_branch,
              :month_branch,
              :year_branch,
              :day_heavenly_void,
              :max_num

  def initialize(date, result, gender, day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, day_heavenly_void)
    @date = date
    @result = result
    @gender = gender
    @day_stem = day_stem
    @month_stem = month_stem
    @year_stem = year_stem
    @day_branch = day_branch
    @month_branch = month_branch
    @year_branch = year_branch
    @day_heavenly_void = day_heavenly_void.gsub('天中殺', '')
    @max_num = SexagenaryCycle::MAX_NUMBER
  end

  def self.call(date, result, gender, day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, day_heavenly_void)
    new(date, result, gender, day_stem, month_stem, year_stem, day_branch, month_branch, year_branch, day_heavenly_void).calculate
  end

  def calculate
    @is_reverse_sequence = build_reverse_sequence
    @first_num = build_first_num
    @first_age = build_first_age
    build_data
  end

  private

  def build_reverse_sequence
    is_yin = year_stem.yin_yang == '陰'

    if gender == 'male'
      is_yin ? true : false
    else
      is_yin ? false : true
    end
  end

  def build_first_num
    month_num = result.sexagenary_cycle_month_id

    if @is_reverse_sequence
      month_num == 1 ? max_num : month_num - 1
    else
      month_num == max_num ? 1 : month_num + 1
    end
  end

  def build_first_age
    day = date.day
    this_entry_day = LunarCalendarEntry.lunar_birth_day(date)
    is_over_entry_day = day >= this_entry_day

    days_diff = if @is_reverse_sequence
      if is_over_entry_day
        # その月の月入日を超えているなら、誕生日 - その月の月入日となる
        (date.to_date - Date.new(date.year, date.month, this_entry_day)).to_i
      else
        # 超えていないなら、前月の月入日
        ((date.to_date) - (LunarCalendarEntry.lunar_birth_day_previous_month_with_datetime(date).to_date)).to_i
      end
    else
      ((LunarCalendarEntry.lunar_birth_day_next_month_with_datetime(date).to_date) - (date.to_date)).to_i
    end

    age = (days_diff / 3.to_f).round
    age = age.zero? ? 1 : age
    age = age > 10 ? 10 : age
    age
  end

  # [
  #   {
  #     stem_and_branch: 甲子,
  #     age: 1,
  #     year: 2020,
  #     major_star: '調舒生',
  #     sub_star: '天報星',
  #     relationship: {
  #       day: '支合',
  #       month: nil,
  #       year: '半会'
  #     },
  #     heavenly_void: heavenly_void
  #   }
  # ]
  def build_data
    9.times.map do |i|
      age = i == 0 ? @first_age : @first_age + (10 * i)
      year = (date.year + age) / 10 * 10
      major_stem, major_branch = build_major_stem_and_branch(i)
      stem_and_branch = major_stem + major_branch
      major_star = MajorStarMapping.find_by(main_stem: day_stem.name, sub_stem: major_stem).ten_major_star
      sub_star = SubStarMapping.find_by(stem: day_stem.name, branch: major_branch).twelve_sub_star
      relationship = {
        day: RelationshipCalculator.call(day_stem.name, day_branch.name, major_stem, major_branch),
        month: RelationshipCalculator.call(month_stem.name, month_branch.name, major_stem, major_branch),
        year: RelationshipCalculator.call(year_stem.name, year_branch.name, major_stem, major_branch)
      }

      {
        stem_and_branch: stem_and_branch,
        age: age,
        year: year,
        major_star: major_star,
        sub_star: sub_star,
        relationship: relationship,
        heavenly_void: build_heavenly_void(major_branch),
        abnormal: build_abnormal(stem_and_branch)
      }
    end
  end

  def build_major_stem_and_branch(num)
    cycle_num = num.zero? ? @first_num : build_cycle_num(num)

    major_cycle = CycleMapping.find(cycle_num)
    major_stem = major_cycle.stem
    major_branch = major_cycle.branch

    [major_stem, major_branch]
  end

  def build_cycle_num(num)
    cycle_num = nil

    # 逆順のときは
    if @is_reverse_sequence
      # 初旬からマイナス
      cycle_num = @first_num - (num)
      # 1より小さくなったら
      if cycle_num < 1
        # 初旬なら
        if num == 1
          # 60にする
          cycle_num = max_num
        else
          # 2旬目以降は60からnum-1を引く
          cycle_num = max_num - (num - 1)
        end
      end
    else
      # 正順のときは初旬にプラス
      cycle_num = @first_num + (num)
      # 60より大きくなったら
      if cycle_num > max_num
        if num == 1
          cycle_num = 1
        else
          # 2旬目以降は60を超えた数値から60を引く
          cycle_num = (cycle_num - max_num)
        end
      end
    end

    cycle_num
  end

  def build_heavenly_void(major_branch_name)
    day_heavenly_void.include?(major_branch_name) ? '⚪︎' : nil
  end

  def build_abnormal(stem_and_branch)
    CycleMapping::ABNORMALS.include?(stem_and_branch) ? '異' : nil
  end
end
