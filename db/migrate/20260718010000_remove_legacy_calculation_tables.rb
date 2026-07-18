class RemoveLegacyCalculationTables < ActiveRecord::Migration[8.0]
  # 命式は Sanmeigaku::StaticData と ActiveHash の静的マスタで算出するため、
  # 旧DBマスタと事前生成結果は不要になった。
  LEGACY_TABLES = %i[
    fortune_analyses
    stem_lineages
    stem_ten_star_mappings
    stem_twelve_star_mappings
    sexagenary_cycles
    branches
    ten_major_stars
    twelve_sub_stars
    stems
    elements
  ].freeze

  def up
    # 外部キーの参照元から順に削除する。
    LEGACY_TABLES.each do |table_name|
      drop_table table_name, if_exists: true
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, '静的マスタへ移行済みのため、旧計算テーブルは復元できません'
  end
end
