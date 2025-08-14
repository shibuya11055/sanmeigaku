class AddPrefectureIdToClients < ActiveRecord::Migration[8.0]
  def change
    add_column :clients, :prefecture_id, :integer
  end
end
