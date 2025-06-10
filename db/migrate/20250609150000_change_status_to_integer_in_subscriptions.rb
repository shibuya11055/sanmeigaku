class ChangeStatusToIntegerInSubscriptions < ActiveRecord::Migration[8.0]
  def up
    change_column :subscriptions, :status, 'integer USING CAST(status AS integer)'
  end

  def down
    change_column :subscriptions, :status, :string
  end
end
