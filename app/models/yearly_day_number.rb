class YearlyDayNumber < ActiveHash::Base
  # 月入日の日番号データ
  self.data = [
    { year: 1925, first_day_numbers: [22, 53, 21, 52, 22, 53, 23, 54, 25, 55, 26, 56] },
    { year: 1926, first_day_numbers: [27, 58, 26, 57, 27, 58, 28, 59, 30, 60, 31, 1] },
    { year: 1927, first_day_numbers: [32,  3, 31, 2, 32, 3, 33, 4, 35, 5, 36, 6] },
    { year: 1928, first_day_numbers: [37,  8, 37, 8, 38, 9, 39, 10, 41, 11, 42, 12] },
    { year: 1929, first_day_numbers: [43, 14, 42, 13, 43, 14, 44, 15, 46, 16, 47, 17] },
    { year: 1930, first_day_numbers: [48, 19, 47, 18, 48, 19, 49, 20, 51, 21, 52, 22] },
    { year: 1931, first_day_numbers: [53, 24, 52, 23, 53, 24, 54, 25, 56, 26, 57, 27] },
    { year: 1932, first_day_numbers: [58, 29, 58, 29, 59, 30, 60, 31, 2, 32, 3, 33] },
    { year: 1933, first_day_numbers: [ 4, 35, 3, 34, 4, 35, 5, 36, 7, 37, 8, 38] },
    { year: 1934, first_day_numbers: [ 9, 40, 8, 39, 9, 40, 10, 41, 12, 42, 13, 43] },
    { year: 1935, first_day_numbers: [14, 45, 13, 44, 14, 45, 15, 46, 17, 47, 18, 48] },
    { year: 1936, first_day_numbers: [19, 50, 19, 50, 20, 51, 21, 52, 23, 53, 24, 54] },
    { year: 1937, first_day_numbers: [25, 56, 24, 55, 25, 56, 26, 57, 28, 58, 29, 59] },
    { year: 1938, first_day_numbers: [30,  1, 29, 60, 30, 1, 31, 2, 33, 3, 34, 4] },
    { year: 1939, first_day_numbers: [35,  6, 34, 5, 35, 6, 36, 7, 38, 8, 39, 9] },
    { year: 1940, first_day_numbers: [40, 11, 40, 11, 41, 12, 42, 13, 44, 14, 45, 15] },
    { year: 1941, first_day_numbers: [46, 17, 45, 16, 46, 17, 47, 18, 49, 19, 50, 20] },
    { year: 1942, first_day_numbers: [51, 22, 50, 21, 51, 22, 52, 23, 54, 24, 55, 25] },
    { year: 1943, first_day_numbers: [56, 27, 55, 26, 56, 27, 57, 28, 59, 29, 60, 30] },
    { year: 1944, first_day_numbers: [ 1, 32, 1, 32, 2, 33, 3, 34, 5, 35, 6, 36] },
    { year: 1945, first_day_numbers: [ 7, 38, 6, 37, 7, 38, 8, 39, 10, 40, 11, 41] },
    { year: 1946, first_day_numbers: [12, 43, 11, 42, 12, 43, 13, 44, 15, 45, 16, 46] },
    { year: 1947, first_day_numbers: [17, 48, 16, 47, 17, 48, 18, 49, 20, 50, 21, 51] },
    { year: 1948, first_day_numbers: [22, 53, 22, 53, 23, 54, 24, 55, 26, 56, 27, 57] },
    { year: 1949, first_day_numbers: [28, 59, 27, 58, 28, 59, 29, 60, 31, 1, 32, 2] },
    { year: 1950, first_day_numbers: [33,  4, 32, 3, 33, 4, 34, 5, 36, 6, 37, 7] },
    { year: 1951, first_day_numbers: [38,  9, 37, 8, 38, 9, 39, 10, 41, 11, 42, 12] },
    { year: 1952, first_day_numbers: [43, 14, 43, 14, 44, 15, 45, 16, 47, 17, 48, 18] },
    { year: 1953, first_day_numbers: [49, 20, 48, 19, 49, 20, 51, 21, 52, 22, 53, 23] },
    { year: 1954, first_day_numbers: [54, 25, 53, 24, 54, 25, 55, 26, 57, 27, 58, 28] },
    { year: 1955, first_day_numbers: [59, 30, 58, 29, 59, 30, 60, 31, 2, 32, 3, 33] },
    { year: 1956, first_day_numbers: [ 4, 35, 4, 35, 5, 36, 6, 37, 8, 38, 9, 39] },
    { year: 1957, first_day_numbers: [10, 41, 9, 40, 10, 41, 11, 42, 13, 43, 14, 44] },
    { year: 1958, first_day_numbers: [15, 46, 14, 45, 15, 46, 16, 47, 18, 48, 19, 49] },
    { year: 1959, first_day_numbers: [20, 51, 19, 50, 20, 51, 21, 52, 23, 53, 24, 54] },
    { year: 1960, first_day_numbers: [25, 56, 25, 56, 26, 57, 27, 58, 29, 59, 30, 60] },
    { year: 1961, first_day_numbers: [31,  2, 30, 1, 31, 2, 32, 3, 34, 4, 35, 5] },
    { year: 1962, first_day_numbers: [36,  7, 35, 6, 36, 7, 37, 8, 39, 9, 40, 10] },
    { year: 1963, first_day_numbers: [41, 12, 40, 11, 41, 12, 42, 13, 44, 14, 45, 15] },
    { year: 1964, first_day_numbers: [46, 17, 46, 17, 47, 18, 48, 19, 50, 20, 51, 21] },
    { year: 1965, first_day_numbers: [52, 23, 51, 22, 52, 23, 53, 24, 55, 25, 56, 26] },
    { year: 1966, first_day_numbers: [57, 28, 56, 27, 57, 28, 58, 29, 60, 30, 1, 31] },
    { year: 1967, first_day_numbers: [ 2, 33, 1, 32, 2, 33, 3, 34, 5, 35, 6, 36] },
    { year: 1968, first_day_numbers: [ 7, 38, 7, 38, 8, 39, 9, 40, 11, 41, 12, 42] },
    { year: 1969, first_day_numbers: [13, 44, 12, 43, 13, 44, 14, 45, 16, 46, 17, 47] },
    { year: 1970, first_day_numbers: [18, 49, 17, 48, 18, 49, 19, 50, 21, 51, 22, 52] },
    { year: 1971, first_day_numbers: [23, 54, 22, 53, 23, 54, 24, 55, 26, 56, 27, 57] },
    { year: 1972, first_day_numbers: [28, 59, 28, 59, 29, 60, 30, 1, 32, 2, 33, 3] },
    { year: 1973, first_day_numbers: [34,  5, 33, 4, 34, 5, 35, 6, 37, 7, 38, 8] },
    { year: 1974, first_day_numbers: [39, 10, 38, 9, 39, 10, 40, 11, 42, 12, 43, 13] },
    { year: 1975, first_day_numbers: [44, 15, 43, 14, 44, 15, 45, 16, 47, 17, 48, 18] },
    { year: 1976, first_day_numbers: [49, 20, 49, 20, 50, 21, 51, 22, 53, 23, 54, 24] },
    { year: 1977, first_day_numbers: [55, 26, 54, 25, 55, 26, 56, 27, 58, 28, 59, 29] },
    { year: 1978, first_day_numbers: [60, 31, 59, 30, 60, 31, 1, 32, 3, 33, 4, 34] },
    { year: 1979, first_day_numbers: [ 5, 36, 4, 35, 5, 36, 6, 37, 8, 38, 9, 39] },
    { year: 1980, first_day_numbers: [10, 41, 10, 41, 11, 42, 12, 43, 14, 44, 15, 45] },
    { year: 1981, first_day_numbers: [16, 47, 15, 46, 16, 47, 17, 48, 19, 49, 20, 50] },
    { year: 1982, first_day_numbers: [21, 52, 20, 51, 21, 52, 22, 53, 24, 54, 25, 55] },
    { year: 1983, first_day_numbers: [26, 57, 25, 56, 26, 57, 27, 58, 29, 59, 30, 60] },
    { year: 1984, first_day_numbers: [31,  2, 31, 2, 32, 3, 33, 4, 35, 5, 36, 6] },
    { year: 1985, first_day_numbers: [37,  8, 36, 7, 37, 8, 38, 9, 40, 10, 41, 11] },
    { year: 1986, first_day_numbers: [42, 13, 41, 12, 42, 13, 43, 14, 45, 15, 46, 16] },
    { year: 1987, first_day_numbers: [47, 18, 46, 17, 47, 18, 48, 19, 50, 20, 51, 21] },
    { year: 1988, first_day_numbers: [52, 23, 52, 23, 53, 24, 54, 25, 56, 26, 57, 27] },
    { year: 1989, first_day_numbers: [58, 29, 57, 28, 58, 29, 59, 30, 1, 31, 2, 32] },
    { year: 1990, first_day_numbers: [ 3, 34, 2, 33, 3, 34, 4, 35, 6, 36, 7, 37] },
    { year: 1991, first_day_numbers: [ 8, 39, 7, 38, 8, 39, 9, 40, 11, 41, 12, 42] },
    { year: 1992, first_day_numbers: [13, 44, 13, 44, 14, 45, 15, 46, 17, 47, 18, 48] },
    { year: 1993, first_day_numbers: [19, 50, 18, 49, 19, 50, 20, 51, 22, 52, 23, 53] },
    { year: 1994, first_day_numbers: [24, 55, 23, 54, 24, 55, 25, 56, 27, 57, 28, 58] },
    { year: 1995, first_day_numbers: [29, 60, 28, 59, 29, 60, 30, 1, 32, 2, 33, 3] },
    { year: 1996, first_day_numbers: [34,  5, 34, 5, 35, 6, 36, 7, 38, 8, 39, 9] },
    { year: 1997, first_day_numbers: [40, 11, 39, 10, 40, 11, 41, 12, 43, 13, 44, 14] },
    { year: 1998, first_day_numbers: [45, 16, 44, 15, 45, 16, 46, 17, 48, 19, 49, 19] },
    { year: 1999, first_day_numbers: [50, 21, 49, 20, 50, 21, 51, 22, 53, 23, 54, 24] },
    { year: 2000, first_day_numbers: [55, 26, 55, 26, 56, 27, 57, 28, 59, 29, 60, 30] },
    { year: 2001, first_day_numbers: [ 1, 32, 60, 31,  1, 32, 2, 33, 4, 34, 5, 35] },
    { year: 2002, first_day_numbers: [ 6, 37,  5, 36,  6, 37, 7, 38, 9, 39, 10, 40] },
    { year: 2003, first_day_numbers: [11, 42, 10, 41, 11, 42, 12, 43, 14, 44, 15, 45] },
    { year: 2004, first_day_numbers: [16, 47, 16, 47, 17, 48, 18, 49, 20, 50, 21, 51] },
    { year: 2005, first_day_numbers: [22, 53, 21, 52, 22, 53, 23, 54, 25, 55, 26, 56] },
    { year: 2006, first_day_numbers: [27, 58, 26, 57, 27, 58, 28, 59, 30, 60, 31, 1] },
    { year: 2007, first_day_numbers: [32,  3, 31,  2, 32,  3, 33, 4, 35, 5, 36, 6] },
    { year: 2008, first_day_numbers: [37,  8, 37,  8, 38,  9, 39, 10, 41, 11, 42, 12] },
    { year: 2009, first_day_numbers: [43, 14, 42, 13, 43, 14, 44, 15, 46, 16, 47, 17] },
    { year: 2010, first_day_numbers: [48, 19, 47, 18, 48, 19, 49, 20, 51, 21, 52, 22] },
    { year: 2011, first_day_numbers: [53, 24, 52, 23, 53, 24, 54, 25, 56, 26, 57, 27] },
    { year: 2012, first_day_numbers: [58, 29, 58, 29, 59, 30, 60, 31, 2, 32, 3, 33] },
    { year: 2013, first_day_numbers: [ 4, 35,  3, 34,  4, 35, 5, 36, 7, 37, 8, 38] },
    { year: 2014, first_day_numbers: [ 9, 40,  8, 39,  9, 40, 10, 41, 12, 42, 13, 43] },
    { year: 2015, first_day_numbers: [14, 45, 13, 44, 14, 45, 15, 46, 17, 47, 18, 48] },
    { year: 2016, first_day_numbers: [19, 50, 19, 50, 20, 51, 21, 52, 23, 53, 24, 54] },
    { year: 2017, first_day_numbers: [25, 56, 24, 55, 25, 56, 26, 57, 28, 58, 29, 59] },
    { year: 2018, first_day_numbers: [30,  1, 29, 60, 30, 1, 31, 2, 33, 3, 34, 4] },
    { year: 2019, first_day_numbers: [35,  6, 34,  5, 35,  6, 36, 7, 38, 8, 39, 9] },
    { year: 2020, first_day_numbers: [40, 11, 40, 11, 41, 12, 42, 13, 44, 14, 45, 15] },
    { year: 2021, first_day_numbers: [46, 17, 45, 16, 46, 17, 47, 18, 49, 19, 50, 20] },
    { year: 2022, first_day_numbers: [51, 22, 50, 21, 51, 22, 52, 23, 54, 24, 55, 25] },
    { year: 2023, first_day_numbers: [56, 27, 55, 26, 56, 27, 57, 28, 59, 29, 60, 30] },
    { year: 2024, first_day_numbers: [ 1, 32,  1, 32,  2, 33, 3, 34, 5, 35, 6, 36] },
    { year: 2025, first_day_numbers: [7, 38, 6, 37, 7, 38, 8, 39, 10, 40, 11, 41] },
    { year: 2026, first_day_numbers: [12, 43, 11, 42, 12, 43, 13, 44, 15, 45, 16, 46] },
    { year: 2027, first_day_numbers: [17, 48, 16, 47, 17, 48, 18, 49, 20, 50, 21, 51] },
    { year: 2028, first_day_numbers: [22, 53, 22, 53, 23, 54, 24, 55, 26, 56, 27, 57] },
    { year: 2029, first_day_numbers: [28, 59, 27, 58, 28, 59, 29, 60, 31, 1, 32, 2] },
    { year: 2030, first_day_numbers: [33,  4, 32,  3, 33,  4, 34, 5, 36, 6, 37, 7] },
    { year: 2031, first_day_numbers: [38, 9, 37, 8, 38, 9, 39, 10, 41, 11, 42, 12] },
    { year: 2032, first_day_numbers: [43, 14, 43, 14, 44, 15, 45, 16, 47, 17, 48, 18] },
    { year: 2033, first_day_numbers: [49, 20, 48, 19, 49, 20, 50, 21, 52, 22, 53, 23] },
    { year: 2034, first_day_numbers: [54, 25, 53, 24, 54, 25, 55, 26, 57, 27, 58, 28] },
    { year: 2035, first_day_numbers: [59, 30, 58, 29, 59, 30, 60, 31, 2, 32, 3, 33] },
    { year: 2036, first_day_numbers: [4, 35, 4, 35, 5, 36, 6, 37, 8, 38, 9, 39] },
    { year: 2037, first_day_numbers: [10, 41, 9, 40, 10, 41, 11, 42, 13, 43, 14, 44] },
    { year: 2038, first_day_numbers: [15, 46, 14, 45, 15, 46, 16, 47, 18, 48, 19, 49] },
    { year: 2039, first_day_numbers: [20, 51, 19, 50, 20, 51, 21, 52, 23, 53, 24, 54] },
    { year: 2040, first_day_numbers: [25, 56, 25, 56, 26, 57, 27, 58, 29, 59, 30, 60] },
    { year: 2041, first_day_numbers: [31,  2, 30,  1, 31,  2, 32, 3, 34, 4, 35, 5] },
    { year: 2042, first_day_numbers: [36,  7, 35,  6, 36,  7, 37, 8, 39, 9, 40, 10] },
    { year: 2043, first_day_numbers: [41, 12, 40, 11, 41, 12, 42, 13, 44, 14, 45, 15] },
    { year: 2044, first_day_numbers: [46, 17, 46, 17, 47, 18, 48, 19, 50, 20, 51, 21] }
  ]

  # 誕生月の始まりの日番号を返す
  def self.day_number(birth_date)
    self.find_by(year: birth_date.year).first_day_numbers[birth_date.month - 1]
  end
end
