class CreateEarthlyBranches < ActiveRecord::Migration[8.0]
  def change
    create_table :earthly_branches do |t|
      t.string :name, null: false
      t.integer :yin_yang, null: false
      t.text :description
      t.references :element, null: false, foreign_key: true
      t.references :first_stem, foreign_key: { to_table: :heavenly_stems }
      t.integer :first_stem_period_day
      t.references :second_stem, foreign_key: { to_table: :heavenly_stems }
      t.integer :second_stem_period_day
      t.references :third_stem, foreign_key: { to_table: :heavenly_stems }
      t.integer :third_stem_period_day

      t.timestamps
    end
  end
end
