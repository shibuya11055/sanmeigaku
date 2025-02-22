class CreateTwelveSubStars < ActiveRecord::Migration[8.0]
  def change
    create_table :twelve_sub_stars, id: false do |t|
      t.integer :id, primary_key: true, null: false
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
