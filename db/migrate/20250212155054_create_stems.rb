class CreateStems < ActiveRecord::Migration[8.0]
  def change
    create_table :stems, id: false do |t|
      t.integer :id, primary_key: true, null: false
      t.string :name, null: false
      t.integer :yin_yang, null: false
      t.text :description
      t.references :element, null: false, foreign_key: true

      t.timestamps
    end
  end
end
