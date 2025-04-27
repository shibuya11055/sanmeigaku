class CreateOccupations < ActiveRecord::Migration[8.0]
  def change
    create_table :occupations, comment: '職種マスタテーブル' do |t|
      t.string :name, null: false, comment: '職種名（例: "エンジニア"）'

      t.timestamps
    end

    add_index :occupations, :name, unique: true
  end
end
