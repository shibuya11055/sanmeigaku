class CreateStemTwelveStarMappings < ActiveRecord::Migration[8.0]
  def change
    create_table :stem_twelve_star_mappings, id: false, comment: '日干、十二支の十二大従星の関係'do |t|
      t.integer :id, primary_key: true, null: false
      t.references :stem, null: false, foreign_key: true, comment: '日干'
      t.references :branch, null: false, foreign_key: true, comment: '十二支'
      t.references :twelve_sub_star, null: false, foreign_key: true, comment: '十二大従星'

      t.timestamps
    end
  end
end
