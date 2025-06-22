class UpdateExistingSubscriptionsWithPlanId < ActiveRecord::Migration[8.0]
  def up
    # 既存のサブスクリプションで plan_name が「ベーシックプラン」のものに plan_id = 1 を設定
    execute <<-SQL
      UPDATE subscriptions
      SET plan_id = 1
      WHERE plan_name = 'ベーシックプラン' AND plan_id IS NULL
    SQL
  end

  def down
    # ロールバック時は plan_id を NULL に戻す
    execute <<-SQL
      UPDATE subscriptions
      SET plan_id = NULL
      WHERE plan_id = 1
    SQL
  end
end
