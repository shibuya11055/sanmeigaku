Rails.application.routes.draw do
  # 他のルーティング
  get 'fortune_analysis', to: 'fortune_analysis#index'
  post 'fortune_analysis/calculate', to: 'fortune_analysis#calculate'
end