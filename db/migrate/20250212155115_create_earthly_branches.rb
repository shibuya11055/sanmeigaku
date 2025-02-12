class CreateEarthlyBranches < ActiveRecord::Migration[8.0]
  def change
    create_table :earthly_branches do |t|
      t.string :name
      t.integer :yin_yang
      t.integer :season
      t.text :description
      t.references :element, null: false, foreign_key: true

      t.timestamps
    end
  end
end
