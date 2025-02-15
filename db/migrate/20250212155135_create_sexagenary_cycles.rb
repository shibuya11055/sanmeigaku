class CreateSexagenaryCycles < ActiveRecord::Migration[8.0]
  def change
    create_table :sexagenary_cycles, id: false do |t|
      t.integer :id, primary_key: true, null: false
      t.string :name, null: false
      t.references :stem, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true
      t.integer :heavenly_void, null: false, comment: '0: 戌亥天中殺, 1: 申酉天中殺, 2: 午未天中殺, 3: 辰已天中殺, 4: 寅卯天中殺, 5: 子丑天中殺'

      t.timestamps
    end
  end
end
