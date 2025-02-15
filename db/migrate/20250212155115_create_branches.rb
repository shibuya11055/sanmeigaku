class CreateBranches < ActiveRecord::Migration[8.0]
  def change
    create_table :branches, id: false do |t|
      t.integer :id, primary_key: true, null: false
      t.string :name, null: false
      t.integer :yin_yang, null: false
      t.text :description
      t.references :element, null: false, foreign_key: true
      t.references :first_stem, foreign_key: { to_table: :stems }
      t.integer :first_stem_period_day
      t.references :second_stem, foreign_key: { to_table: :stems }
      t.integer :second_stem_period_day
      t.references :third_stem, foreign_key: { to_table: :stems }
      t.integer :third_stem_period_day

      t.timestamps
    end
  end
end
