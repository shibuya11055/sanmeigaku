class AddPlanIdToSubscriptions < ActiveRecord::Migration[8.0]
  def change
    add_column :subscriptions, :plan_id, :integer
  end
end
