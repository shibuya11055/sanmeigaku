class Plan < ActiveHash::Base
  self.data = [
    {
      id: 1,
      name: "有料プラン",
      price: 5000,
      currency: "jpy",
      interval: "month",
      description: "月額5000円の有料プランで、すべての機能をご利用いただけます。",
      stripe_product_name: "有料プラン"
    }
  ]

  # インスタンスメソッド
  def price_in_yen
    price
  end

  def formatted_price
    "#{price_in_yen}円"
  end

  def monthly_description
    "月額 #{formatted_price}"
  end

  # クラスメソッド
  def self.basic_plan
    find(1)
  end

  def self.find_by_name(name)
    all.find { |plan| plan.name == name }
  end
end
