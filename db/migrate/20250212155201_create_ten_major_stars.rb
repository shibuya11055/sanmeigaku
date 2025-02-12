class CreateTenMajorStars < ActiveRecord::Migration[8.0]
  def change
    create_table :ten_major_stars do |t|
      t.string :name
      t.text :description
      t.integer :yin_yang
      t.references :element, null: false, foreign_key: true
      t.string :compatibility

      t.timestamps
    end
  end
end
