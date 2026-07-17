require 'fileutils'
require 'json'

namespace :sanmeigaku do
  namespace :site_comparison do
    DEFAULT_OUTPUT = Rails.root.join('tmp/sanmeigaku_site_comparison').freeze
    DEFAULT_CASES = DEFAULT_OUTPUT.join('cases.json').freeze
    DEFAULT_RESULTS = DEFAULT_OUTPUT.join('results.json').freeze

    desc '公式サイトとの比較対象日をJSONに生成する'
    task :generate, %i[count seed output] => :environment do |_task, args|
      count = (args[:count].presence || Sanmeigaku::SiteComparison::DEFAULT_COUNT).to_i
      seed = (args[:seed].presence || Sanmeigaku::SiteComparison::DEFAULT_SEED).to_i
      output = Pathname.new(args[:output].presence || DEFAULT_CASES)
      dates = Sanmeigaku::SiteComparison.generate_cases(count:, seed:)

      FileUtils.mkdir_p(output.dirname)
      File.write(
        output,
        JSON.pretty_generate(
          'version' => 1,
          'source' => Sanmeigaku::SiteComparison::SITE_URL,
          'seed' => seed,
          'cases' => dates.map { |date| { 'date' => date.iso8601 } }
        )
      )
      puts "#{dates.length}件を #{output} に保存しました"
    end

    desc '公式サイトから結果を取得して比較結果をJSONに保存する（外部アクセス）'
    task :fetch, %i[count seed delay input output] => :environment do |_task, args|
      count = (args[:count].presence || Sanmeigaku::SiteComparison::DEFAULT_COUNT).to_i
      seed = (args[:seed].presence || Sanmeigaku::SiteComparison::DEFAULT_SEED).to_i
      delay = (args[:delay].presence || 1.0).to_f
      input = Pathname.new(args[:input].presence || DEFAULT_CASES)
      output = Pathname.new(args[:output].presence || DEFAULT_RESULTS)

      unless input.exist?
        Rake::Task['sanmeigaku:site_comparison:generate'].invoke(count, seed, input.to_s)
      end

      cases = JSON.parse(input.read).fetch('cases').first(count)
      client = Sanmeigaku::SiteComparison::SiteClient.new
      records = cases.each_with_index.map do |entry, index|
        date = Date.iso8601(entry.fetch('date'))
        site_result = client.fetch(date)
        local_result = Sanmeigaku::SiteComparison.local_result(date)
        comparison = Sanmeigaku::SiteComparison.compare(local: local_result, site: site_result)
        puts format('%<current>d/%<total>d %<date>s: %<status>s', current: index + 1, total: cases.length, date:, status: comparison['status'])
        sleep(delay) if delay.positive? && index < cases.length - 1

        {
          'date' => date.iso8601,
          'local' => local_result,
          'site' => site_result,
          'comparison' => comparison
        }
      end

      FileUtils.mkdir_p(output.dirname)
      File.write(
        output,
        JSON.pretty_generate(
          'version' => 1,
          'source' => Sanmeigaku::SiteComparison::SITE_URL,
          'endpoint' => Sanmeigaku::SiteComparison::SITE_ENDPOINT,
          'seed' => seed,
          'count' => records.length,
          'results' => records
        )
      )
      puts "比較結果を #{output} に保存しました"
    end

    desc '保存済み比較結果JSONの集計を表示する'
    task :report, [:input] => :environment do |_task, args|
      input = Pathname.new(args[:input].presence || DEFAULT_RESULTS)
      results = JSON.parse(input.read).fetch('results')
      counts = results.group_by { |record| record.dig('comparison', 'status') }.transform_values(&:length)
      puts JSON.pretty_generate('total' => results.length, 'statuses' => counts)

      results.reject { |record| record.dig('comparison', 'status') == 'match' }.each do |record|
        puts "#{record['date']}: #{record.dig('comparison', 'status')}"
        puts JSON.pretty_generate(record.dig('comparison', 'mismatches'))
      end
    end

    desc '保存済み比較結果JSONを自動検証する'
    task :verify, [:input] => :environment do |_task, args|
      input = Pathname.new(args[:input].presence || DEFAULT_RESULTS)
      payload = JSON.parse(input.read)
      failures = Sanmeigaku::SiteComparison.verify_results(payload)

      if failures.empty?
        puts "#{payload.fetch('results').length}件すべて一致しました"
      else
        puts "#{failures.length}件の不一致またはエラーがあります"
        puts JSON.pretty_generate(failures)
        abort
      end
    end
  end
end
