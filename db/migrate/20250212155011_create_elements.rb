class CreateElements < ActiveRecord::Migration[8.0]
  def change
    create_table :elements do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
