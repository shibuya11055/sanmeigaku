class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :stripe_customer_id
      t.string :stripe_subscription_id
      t.string :status
      t.string :plan_name
      t.integer :amount
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
