class CreateFortuneAnalyses < ActiveRecord::Migration[8.0]
  def change
    create_table :fortune_analyses do |t|
      t.date :birthday, null: false
      t.references :sexagenary_cycle_year, null: false, foreign_key: { to_table: :sexagenary_cycles }
      t.references :sexagenary_cycle_month, null: false, foreign_key: { to_table: :sexagenary_cycles }
      t.references :sexagenary_cycle_day, null: false, foreign_key: { to_table: :sexagenary_cycles }
      t.text :description

      t.timestamps
    end
  end
end
