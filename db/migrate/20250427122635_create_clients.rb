class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients, comment: 'クライアント情報テーブル' do |t|
      t.string :fullname, null: false, comment: 'クライアントの名前（ニックネーム可）'
      t.date :birthday, null: false, comment: '生年月日'
      t.integer :gender, null: false, comment: '性別 0=男性(male), 1=女性(female)'
      t.integer :blood_type, comment: '血液型 0=A型, 1=B型, 2=O型, 3=AB型, 4=不明(unknown)'
      t.integer :marital_status, comment: '婚姻状況 0=未婚(single), 1=既婚(married), 2=離婚(divorced), 3=死別(widowed)'
      t.string :birthplace, comment: '出生地（都道府県など）'
      t.text :memo, comment: '自由記述欄'
      t.references :user, null: false, foreign_key: true, comment: '所有するユーザーID'
      t.references :job, null: true, foreign_key: true, comment: '職業ID'
      t.references :occupation, null: true, foreign_key: true, comment: '職種ID'

      t.timestamps
    end

    add_index :clients, [:user_id, :fullname]
  end
end
