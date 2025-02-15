class CreateTenMajorStars < ActiveRecord::Migration[8.0]
  def change
    create_table :ten_major_stars, id: false do |t|
      t.integer :id, primary_key: true, null: false
      t.string :name, null: false
      t.text :description
      t.integer :yin_yang, null: false
      t.references :element, null: false, foreign_key: true

      t.timestamps
    end
  end
end
