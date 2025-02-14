class CreateHeavenlyStems < ActiveRecord::Migration[8.0]
  def change
    create_table :heavenly_stems do |t|
      t.string :name, null: false
      t.integer :yin_yang, null: false
      t.text :description
      t.references :element, null: false, foreign_key: true

      t.timestamps
    end
  end
end
