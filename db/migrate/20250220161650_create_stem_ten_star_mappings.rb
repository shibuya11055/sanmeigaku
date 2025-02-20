class CreateStemTenStarMappings < ActiveRecord::Migration[8.0]
  def change
    create_table :stem_ten_star_mappings, id: false, comment: '日干気、他気、十大主星の関係' do |t|
      t.integer :id, primary_key: true, null: false
      t.references :main_stem, null: false, foreign_key: { to_table: :stems }, comment: '日干気'
      t.references :sub_stem, null: false, foreign_key: { to_table: :stems }, comment: '他気'
      t.references :ten_major_star, null: false, foreign_key: true, comment: '十大主星'
      t.timestamps
    end
  end
end
