class CreateJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :jobs, comment: '職業マスタテーブル' do |t|
      t.string :name, null: false, comment: '職業名（例: "会社員"）'

      t.timestamps
    end

    add_index :jobs, :name, unique: true
  end
end
