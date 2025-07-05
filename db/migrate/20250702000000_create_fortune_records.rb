class CreateFortuneRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :fortune_records do |t|
      t.references :client, null: false, foreign_key: true, comment: 'クライアントID（外部キー）'
      t.datetime :start_at, null: false, comment: '占い開始日時'
      t.datetime :end_at, null: false, comment: '占い終了日時'
      t.integer :amount, null: false, comment: '占いの金額'
      t.text :content, null: false, comment: '占いのカルテ（テキスト情報）'
      t.integer :category, null: false, comment: '相談内容カテゴリ(enum)'
      t.integer :consultation_method, null: false, comment: '相談手段(enum)'
      t.timestamps
    end
  end
end
