# 職業（Job）マスタデータ
jobs = [
  { id: 1, name: '会社員' },
  { id: 2, name: '経営者・役員' },
  { id: 3, name: '自営業' },
  { id: 4, name: '公務員' },
  { id: 5, name: '医師' },
  { id: 6, name: '弁護士' },
  { id: 7, name: '教師' },
  { id: 8, name: '看護師' },
  { id: 9, name: '主婦・主夫' },
  { id: 10, name: '学生' },
  { id: 11, name: 'アルバイト・パート' },
  { id: 12, name: 'フリーランス' },
  { id: 13, name: '退職者' },
  { id: 14, name: '無職' },
  { id: 15, name: 'その他' }
]

puts "職業（Job）データを登録しています..."
jobs.each do |job|
  # 同じIDで既に存在する場合はスキップ
  next if Job.exists?(id: job[:id])
  Job.create!(job)
end
puts "職業（Job）データの登録が完了しました"

# 職種（Occupation）マスタデータ
occupations = [
  { id: 1, name: '農林水産業' },
  { id: 2, name: '建設業' },
  { id: 3, name: '製造業' },
  { id: 4, name: '電気・ガス・水道業' },
  { id: 5, name: '情報通信業' },
  { id: 6, name: '運輸業' },
  { id: 7, name: '卸売・小売業' },
  { id: 8, name: '金融・保険業' },
  { id: 9, name: '不動産業' },
  { id: 10, name: '飲食・宿泊業' },
  { id: 11, name: '医療・福祉' },
  { id: 12, name: '教育・学習支援' },
  { id: 13, name: 'サービス業' },
  { id: 14, name: '公務' },
  { id: 15, name: '芸能・エンターテイメント' },
  { id: 16, name: 'スポーツ' },
  { id: 17, name: 'その他' }
]

puts "職種（Occupation）データを登録しています..."
occupations.each do |occupation|
  # 同じIDで既に存在する場合はスキップ
  next if Occupation.exists?(id: occupation[:id])
  Occupation.create!(occupation)
end
puts "職種（Occupation）データの登録が完了しました"
