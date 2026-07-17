require 'date'
require 'json'
require 'net/http'
require 'uri'

module Sanmeigaku
  class SiteComparison
    SITE_URL = 'https://www.sanmei-gaku.com/yourself/'.freeze
    SITE_ENDPOINT = 'https://www.sanmei-gaku.com/wp-json/api/hoshidashi'.freeze
    MIN_DATE = Date.new(1925, 2, 1)
    MAX_DATE = Date.new(2044, 12, 31)
    DEFAULT_COUNT = 1_000
    DEFAULT_SEED = 20_260_718
    PRIORITY_DATES = [
      Date.new(1925, 2, 3), Date.new(1925, 2, 4), Date.new(1925, 2, 5),
      Date.new(1926, 2, 3), Date.new(1926, 2, 4), Date.new(1926, 2, 5),
      Date.new(1947, 6, 25), Date.new(1952, 2, 4), Date.new(1952, 2, 5), Date.new(1952, 2, 6),
      Date.new(1965, 2, 3), Date.new(1965, 2, 4), Date.new(1965, 2, 5), Date.new(1973, 9, 24),
      Date.new(1977, 4, 5), Date.new(1982, 6, 7), Date.new(1996, 3, 5), Date.new(2001, 7, 7),
      Date.new(2003, 2, 3), Date.new(2003, 2, 4), Date.new(2003, 2, 5), Date.new(2013, 12, 7)
    ].freeze

    class SiteClient
      def initialize(open_timeout: 10, read_timeout: 30)
        @open_timeout = open_timeout
        @read_timeout = read_timeout
      end

      def fetch(birth_date)
        date = birth_date.to_date
        uri = URI(SITE_ENDPOINT)
        request = Net::HTTP::Post.new(uri)
        request['Content-Type'] = 'application/json'
        request['Accept'] = 'application/json'
        request['User-Agent'] = 'sanmeigaku-validation/1.0'
        request.body = JSON.generate(
          nengo: '西暦',
          y_inp: date.year.to_s,
          m_inp: date.month.to_s,
          d_inp: date.day.to_s
        )

        response = Net::HTTP.start(
          uri.host,
          uri.port,
          use_ssl: uri.scheme == 'https',
          open_timeout: @open_timeout,
          read_timeout: @read_timeout
        ) { |http| http.request(request) }

        return { 'error' => "サイトがHTTP #{response.code}を返しました", 'http_status' => response.code.to_i } unless response.is_a?(Net::HTTPSuccess)

        body = JSON.parse(response.body)
        body['http_status'] = response.code.to_i
        body
      rescue JSON::ParserError => e
        { 'error' => "サイトのJSONを解釈できません: #{e.message}", 'http_status' => response ? response.code.to_i : nil }
      rescue StandardError => e
        { 'error' => "サイトへの接続に失敗しました: #{e.message}", 'error_class' => e.class.name }
      end
    end

    class << self
      def generate_cases(count: DEFAULT_COUNT, seed: DEFAULT_SEED)
        raise ArgumentError, 'countは1以上で指定してください' unless count.to_i.positive?

        random = Random.new(seed.to_i)
        date_span = (MAX_DATE - MIN_DATE).to_i + 1
        boundary_target = [count.to_i / 2, 1].max
        dates = PRIORITY_DATES.select { |date| date.between?(MIN_DATE, MAX_DATE) }.first(count.to_i)
        available_boundaries = (boundary_dates - dates).shuffle(random: random)
        dates.concat(available_boundaries.first([boundary_target - dates.length, 0].max))

        while dates.length < count.to_i
          dates << MIN_DATE + random.rand(date_span)
          dates.uniq!
        end

        dates.first(count.to_i).sort
      end

      def local_result(birth_date)
        date = birth_date.to_date
        result = NatalChartCalculator.call(birth_date: date)
        year_cycle = result.sexagenary_cycle_year
        month_cycle = result.sexagenary_cycle_month
        day_cycle = result.sexagenary_cycle_day
        basic_results = FortuneAnalysisBasicResults.new(
          day_cycle.stem,
          month_cycle.stem,
          year_cycle.stem,
          day_cycle.branch,
          month_cycle.branch,
          year_cycle.branch,
          year_cycle.heavenly_void,
          day_cycle.heavenly_void,
          date,
          result
        )
        year_qi_stem, month_qi_stem, day_qi_stem = basic_results.birth_qi
        ten_stars, twelve_stars = YangChartCalculator.call(
          day_qi_stem,
          month_qi_stem,
          year_qi_stem,
          day_cycle.stem,
          month_cycle.stem,
          year_cycle.stem,
          day_cycle.branch,
          month_cycle.branch,
          year_cycle.branch
        )

        {
          'date' => date.iso8601,
          'year_num' => result.sexagenary_cycle_year_id,
          'month_num' => result.sexagenary_cycle_month_id,
          'day_num' => result.sexagenary_cycle_day_id,
          'year' => year_cycle.stem_and_branch,
          'month' => month_cycle.stem_and_branch,
          'day' => day_cycle.stem_and_branch,
          # 公式サイトの配列順: 日干・月干・年干・日支・月支・年支・日蔵干・月蔵干・年蔵干
          'insen' => [
            day_cycle.stem.name,
            month_cycle.stem.name,
            year_cycle.stem.name,
            day_cycle.branch.name,
            month_cycle.branch.name,
            year_cycle.branch.name,
            day_qi_stem.name,
            month_qi_stem.name,
            year_qi_stem.name
          ],
          # 公式サイトの陽占表示順（画面上段左から右、次に中段、下段）
          'yousen' => [
            ten_stars[:north].name,
            twelve_stars[:third].name,
            ten_stars[:west].name,
            ten_stars[:center].name,
            ten_stars[:east].name,
            twelve_stars[:first].name,
            ten_stars[:south].name,
            twelve_stars[:second].name
          ].map { |name| normalize_star_name(name) },
          'tentyusatsu' => day_cycle.heavenly_void
        }
      end

      def compare(local:, site:)
        return { 'status' => 'error', 'mismatches' => [site['error'].to_s] } if site['error'].present?

        mismatches = []
        compare_field(mismatches, 'insen', local['insen'], site['insen'])
        compare_field(mismatches, 'yousen', local['yousen'], site['yousen'].to_a.map { |name| normalize_star_name(name) })
        compare_field(
          mismatches,
          'tentyusatsu',
          local['tentyusatsu'],
          site['tentyusatsu'].to_s.delete_suffix('天中殺')
        )

        {
          'status' => mismatches.empty? ? 'match' : 'mismatch',
          'mismatches' => mismatches
        }
      end

      def verify_results(payload)
        payload.fetch('results').filter_map do |record|
          date = Date.iso8601(record.fetch('date'))
          local = local_result(date)
          comparison = compare(local:, site: record.fetch('site'))
          next if comparison['status'] == 'match'

          { 'date' => date.iso8601, 'comparison' => comparison }
        end
      end

      private

      def boundary_dates
        dates = []
        (MIN_DATE.year..MAX_DATE.year).each do |year|
          entry = LunarCalendarEntry.find_by(year: year)
          next unless entry

          entry.entries.each_with_index do |entry_day, month_index|
            next unless entry_day

            (-1..1).each do |offset|
              date = Date.new(year, month_index + 1, entry_day + offset)
              dates << date if date.between?(MIN_DATE, MAX_DATE)
            end
          end
        end
        dates.uniq
      end

      def compare_field(mismatches, field, expected, actual)
        return if expected == actual

        mismatches << {
          'field' => field,
          'expected' => expected,
          'actual' => actual
        }
      end

      def normalize_star_name(name)
        name.to_s.delete_suffix('星').tr('禄', '祿')
      end
    end
  end
end
