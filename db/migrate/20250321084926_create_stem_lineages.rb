class CreateStemLineages < ActiveRecord::Migration[8.0]
  def change
    create_table :stem_lineages do |t|
      t.references :day_stem, null: false, foreign_key: { to_table: :stems }
      t.references :m_stem, null: false, foreign_key: { to_table: :stems }
      t.references :f_stem, null: false, foreign_key: { to_table: :stems }
      t.references :m_grandmother_stem, null: false, foreign_key: { to_table: :stems }
      t.references :m_grandfather_stem, null: false, foreign_key: { to_table: :stems }
      t.references :f_grandmother_stem, null: false, foreign_key: { to_table: :stems }
      t.references :f_grandfather_stem, null: false, foreign_key: { to_table: :stems }
      t.references :spouse_stem, null: false, foreign_key: { to_table: :stems }
      t.references :mother_in_law_stem, null: false, foreign_key: { to_table: :stems }
      t.references :father_in_law_stem, null: false, foreign_key: { to_table: :stems }
      t.references :male_child_stem, null: false, foreign_key: { to_table: :stems }
      t.references :female_child_stem, null: false, foreign_key: { to_table: :stems }
      t.references :male_child_spouse_stem, null: false, foreign_key: { to_table: :stems }
      t.references :female_child_spouse_stem, null: false, foreign_key: { to_table: :stems }

      t.timestamps
    end
  end
end
