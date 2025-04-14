class CalendarDetail < ApplicationRecord
  require "net/http"
  require "uri"
  require "json"

  self.abstract_class = true

  def self.yearly_stem_and_branch
    stems = Stem.pluck(:name)
    branches = Branch.pluck(:name)

    # 1924年から2100年までの干支対応表を生成
    table = (1924..2200).map do |year|
      # 干と支のインデックスを計算
      # 1924年が甲子なので、それを基準に計算
      stem_index = (year - 4) % 10  # (1924-4)%10=0 → 甲
      branch_index = (year - 4) % 12  # (1924-4)%12=0 → 子
      
      # ハッシュとして年と対応する干支を格納
      {
        year: year,
        stem: stems[stem_index],
        branch: branches[branch_index],
        stem_and_branch: "#{stems[stem_index]}#{branches[branch_index]}"
      }
    end

    table
  end

  # 日付ごとの干支を取得するAPI
  def self.get_calendar_data(options = {})
    # デフォルト値の設定
    today = Time.now
    default_options = {
      mode: "m",               # デフォルトは月単位
      cnt: 1,                  # デフォルトは1つ分
      targetyyyy: today.year,  # 今年
      targetmm: today.month,   # 今月
      targetdd: today.day      # 今日
    }
    
    # オプションをマージ
    params = default_options.merge(options)
    
    # APIエンドポイントの構築
    uri = URI.parse("https://koyomi.zingsystem.com/api/")
    uri.query = URI.encode_www_form(params)
    
    # APIリクエスト実行
    response = Net::HTTP.get_response(uri)

    JSON.parse(response.body)
  end
end
