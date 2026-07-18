class CalendarDetail < ApplicationRecord
  require 'net/http'
  require 'uri'
  require 'json'

  self.abstract_class = true

  def self.yearly_stem_and_branch
    Sanmeigaku::StaticData.yearly_stem_and_branch
  end

  # 日付ごとの干支を取得するAPI
  def self.get_calendar_data(options = {})
    # デフォルト値の設定
    today = Time.now
    default_options = {
      mode: 'm',               # デフォルトは月単位
      cnt: 1,                  # デフォルトは1つ分
      targetyyyy: today.year,  # 今年
      targetmm: today.month,   # 今月
      targetdd: today.day      # 今日
    }

    # オプションをマージ
    params = default_options.merge(options)

    # APIエンドポイントの構築
    uri = URI.parse('https://koyomi.zingsystem.com/api/')
    uri.query = URI.encode_www_form(params)

    # APIリクエスト実行
    response = Net::HTTP.get_response(uri)

    JSON.parse(response.body)
  end
end
