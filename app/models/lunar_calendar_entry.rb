class LunarCalendarEntry < ActiveHash::Base
  # 干支歴における月入日のデータ
  self.data = [
    { year: 1925, entries: [6,4,6,5,6,6,8,8,8,9,8,7] },
    { year: 1926, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1927, entries: [6,5,6,6,6,7,8,8,9,9,8,8] },
    { year: 1928, entries: [6,5,6,5,6,6,7,8,8,8,8,7] },
    { year: 1929, entries: [6,4,6,5,6,6,8,8,8,9,8,7] },
    { year: 1930, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1931, entries: [6,5,6,6,6,7,8,8,9,9,8,8] },
    { year: 1932, entries: [6,5,6,5,6,6,7,8,8,8,7,7] },
    { year: 1933, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 1934, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1935, entries: [6,5,6,6,6,7,8,8,8,9,8,8] },
    { year: 1936, entries: [6,5,6,5,6,6,7,8,8,8,7,7] },
    { year: 1937, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 1938, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1939, entries: [6,5,6,6,6,6,8,8,8,9,8,8] },
    { year: 1940, entries: [6,5,6,5,6,6,7,8,8,8,7,7] },
    { year: 1941, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 1942, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1943, entries: [6,5,6,6,6,6,8,8,8,9,8,8] },
    { year: 1944, entries: [6,5,6,5,6,6,7,8,8,8,7,7] },
    { year: 1945, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 1946, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1947, entries: [6,5,6,6,6,6,8,8,8,9,8,8] },
    { year: 1948, entries: [6,5,6,5,5,6,7,8,8,8,7,7] },
    { year: 1949, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 1950, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1951, entries: [6,5,6,5,6,6,8,8,8,9,8,8] },
    { year: 1952, entries: [6,5,6,5,5,6,7,7,8,8,7,7] },
    { year: 1953, entries: [6,4,6,5,6,6,7,8,8,8,8,7] },
    { year: 1954, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1955, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1956, entries: [6,5,5,5,5,6,7,7,8,8,7,7] },
    { year: 1957, entries: [5,4,6,5,6,6,7,8,8,8,8,7] },
    { year: 1958, entries: [6,4,6,5,6,6,8,8,8,9,8,7] },
    { year: 1959, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1960, entries: [6,5,5,5,5,6,7,7,8,8,7,7] },
    { year: 1961, entries: [5,4,6,5,6,6,7,8,8,8,8,7] },
    { year: 1962, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 1963, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1964, entries: [6,5,5,5,5,6,7,7,8,8,7,7] },
    { year: 1965, entries: [5,4,6,5,6,6,7,8,8,8,8,7] },
    { year: 1966, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 1967, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1968, entries: [6,5,5,5,5,6,7,7,7,8,7,7] },
    { year: 1969, entries: [5,4,6,5,6,6,7,8,8,8,7,7] },
    { year: 1970, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 1971, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1972, entries: [6,5,5,5,5,5,7,7,7,8,7,7] },
    { year: 1973, entries: [5,4,6,5,6,6,7,8,8,8,7,7] },
    { year: 1974, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 1975, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1976, entries: [6,5,5,5,5,5,7,7,7,8,7,7] },
    { year: 1977, entries: [5,4,6,5,6,6,7,8,8,8,7,7] },
    { year: 1978, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 1979, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1980, entries: [6,5,5,5,5,5,7,7,7,8,7,7] },
    { year: 1981, entries: [5,4,6,5,5,6,7,7,8,8,7,7] },
    { year: 1982, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 1983, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1984, entries: [6,5,5,4,5,5,7,7,7,8,7,7] },
    { year: 1985, entries: [5,4,6,5,5,6,7,7,8,8,7,7] },
    { year: 1986, entries: [6,4,6,5,6,6,7,8,8,8,8,7] },
    { year: 1987, entries: [6,4,6,5,6,6,8,8,8,9,8,8] },
    { year: 1988, entries: [6,4,5,4,5,5,7,7,7,8,7,7] },
    { year: 1989, entries: [5,4,5,5,5,6,7,7,8,8,7,7] },
    { year: 1990, entries: [5,4,6,5,6,6,7,8,8,8,8,7] },
    { year: 1991, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 1992, entries: [6,4,5,4,5,5,7,7,7,8,7,7] },
    { year: 1993, entries: [5,4,5,5,5,6,7,7,8,8,7,7] },
    { year: 1994, entries: [5,4,6,5,6,6,7,8,8,8,8,7] },
    { year: 1995, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 1996, entries: [6,4,5,4,5,5,7,7,7,8,7,7] },
    { year: 1997, entries: [5,4,5,5,5,6,7,7,7,8,7,7] },
    { year: 1998, entries: [5,4,6,5,6,6,7,8,8,8,8,7] },
    { year: 1999, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 2000, entries: [6,4,5,4,5,5,7,7,7,8,7,7] },
    { year: 2001, entries: [5,4,5,5,5,5,7,7,7,8,7,7] },
    { year: 2002, entries: [5,4,6,5,6,6,7,8,8,8,7,7] },
    { year: 2003, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 2004, entries: [6,4,5,4,5,5,7,7,7,8,7,7] },
    { year: 2005, entries: [5,4,5,5,5,5,7,7,7,8,7,7] },
    { year: 2006, entries: [5,4,6,5,6,6,7,8,8,8,7,7] },
    { year: 2007, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 2008, entries: [6,4,5,4,5,5,7,7,7,8,7,7] },
    { year: 2009, entries: [5,4,5,5,5,5,7,7,7,8,7,7] },
    { year: 2010, entries: [5,4,6,5,5,6,7,7,8,8,7,7] },
    { year: 2011, entries: [6,4,6,5,6,6,7,8,8,9,8,7] },
    { year: 2012, entries: [6,4,5,4,5,5,7,7,7,8,7,7] },
    { year: 2013, entries: [5,4,5,5,5,5,7,7,7,8,7,7] },
    { year: 2014, entries: [5,4,6,5,5,6,7,7,8,8,7,7] },
    { year: 2015, entries: [6,4,6,5,6,6,7,8,8,8,8,7] },
    { year: 2016, entries: [6,4,5,4,5,5,7,7,7,8,7,7] },
    { year: 2017, entries: [5,4,5,4,5,5,7,7,7,8,7,7] },
    { year: 2018, entries: [5,4,6,5,5,6,7,7,8,8,7,7] },
    { year: 2019, entries: [6,4,6,5,6,6,7,8,8,8,8,7] },
    { year: 2020, entries: [6,4,5,4,5,5,7,7,7,8,7,7] },
    { year: 2021, entries: [5,3,5,4,5,5,7,7,7,8,7,7] },
    { year: 2022, entries: [5,4,5,5,5,6,7,7,8,8,7,7] },
    { year: 2023, entries: [6,4,6,5,6,6,7,8,8,8,8,7] },
    { year: 2024, entries: [6,4,5,4,5,5,6,7,7,8,7,7] },
    { year: 2025, entries: [5,3,5,4,5,5,7,7,7,8,7,7] },
    { year: 2026, entries: [5,4,5,5,5,6,7,7,7,8,7,7] },
    { year: 2027, entries: [5,4,6,5,6,6,7,8,8,8,8,7] },
    { year: 2028, entries: [6,4,5,4,5,5,6,7,7,8,7,6] },
    { year: 2029, entries: [5,3,5,4,5,5,7,7,7,8,7,7] },
    { year: 2030, entries: [5,4,5,5,5,5,7,7,7,8,7,7] },
    { year: 2031, entries: [5,4,6,5,6,6,7,8,8,8,8,7] },
    { year: 2032, entries: [6,4,5,4,5,5,6,7,7,8,7,6] },
    { year: 2033, entries: [5,3,5,4,5,5,7,7,7,8,7,7] },
    { year: 2034, entries: [5,4,5,5,5,5,7,7,7,8,7,7] },
    { year: 2035, entries: [5,4,6,5,6,6,7,8,8,8,7,7] },
    { year: 2036, entries: [6,4,5,4,5,5,6,7,7,8,7,6] },
    { year: 2037, entries: [5,3,5,4,5,5,7,7,7,8,7,7] },
    { year: 2038, entries: [5,4,5,5,5,5,7,7,7,8,7,7] },
    { year: 2039, entries: [5,4,6,5,6,6,7,8,8,8,7,7] },
    { year: 2040, entries: [6,4,5,4,5,5,6,7,7,8,7,6] },
    { year: 2041, entries: [5,3,5,4,5,5,7,7,7,8,7,7] },
    { year: 2042, entries: [5,4,5,5,5,5,7,7,7,8,7,7] },
    { year: 2043, entries: [5,4,6,5,5,6,7,7,8,8,7,7] },
    { year: 2044, entries: [6,4,5,4,5,5,6,7,7,8,7,6] },
  ]

  # 誕生月の始まりの日を返す
  def self.lunar_birth_day(birth_date)
    self.find_by(year: birth_date.year).entries[birth_date.month - 1]
  end

  # 誕生月の前月の終わりの日を返す
  def self.lunar_birth_last_day_previous_month(birth_date)
    if birth_date.month == 1
      # 前年の12月末の日付を返す
      previous_year = birth_date.year - 1
      last_day_of_december = Date.new(previous_year, 12, -1)
      return last_day_of_december.day
    else
      # 前月の終わりの日付を返す
      previous_month = birth_date.prev_month
      last_day_of_previous_month = Date.new(previous_month.year, previous_month.month, -1)
      return last_day_of_previous_month.day
    end
  end

  # 前月の月入日を返す
  def self.lunar_birth_day_previous_month(birth_date)
    if birth_date.month == 1
      return self.find_by(year: birth_date.year - 1).entries[11]
    end

    self.find_by(year: birth_date.year).entries[birth_date.month - 2]
  end

  # 前月の月入日（年月日を返す）
  def self.lunar_birth_day_previous_month_with_datetime(birth_date)
    if birth_date.month == 1
      year = birth_date.year - 1
      month = 12
      day = self.find_by(year: year).entries[11]
      return Time.new(year, month, day)
    end

    year = birth_date.year
    month = birth_date.month - 1
    day = self.find_by(year: year).entries[month - 1]
    return Time.new(year, month, day)
  end

  # 翌月の月入日（年月日を返す）
  def self.lunar_birth_day_next_month_with_datetime(birth_date)
    if birth_date.month == 12
      year = birth_date.year + 1
      month = 1
      day = self.find_by(year: year).entries[0]
      return Time.new(year, month, day)
    end

    year = birth_date.year
    month = birth_date.month + 1
    day = self.find_by(year: year).entries[month - 1]
    return Time.new(year, month, day)
  end

  def self.current_year?(birth_date)
    year = birth_date.year
    boundary_date = Date.new(year, 2, 7)

    # 2月7日以降であれば干支歴で今年であることが確定する（2044年までのデータで）
    return true if birth_date >= boundary_date

    # 1月であれば干支歴で去年であることが確定する
    return false if birth_date.month == 1

    # 誕生日が2月の初日以降であれば今年である
    birth_date.day <= self.find_by(year: year).entries[1]
  end
end
