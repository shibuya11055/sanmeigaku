class CreateSexagenaryCycles < ActiveRecord::Migration[8.0]
  def change
    create_table :sexagenary_cycles do |t|
      t.integer :number
      t.string :name
      t.references :heavenly_stem, null: false, foreign_key: true
      t.references :earthly_branch, null: false, foreign_key: true
      t.integer :heavenly_void

      t.timestamps
    end
  end
end
