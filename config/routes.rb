Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks'
  }

  # ルートパスを直接 fortune_analysis#index に設定
  root to: 'fortune_analysis#index'

  # 他のルーティング
  get 'fortune_analysis', to: 'fortune_analysis#index'
  post 'fortune_analysis/calculate', to: 'fortune_analysis#calculate'

  # メール送信完了画面
  get 'users/mail_sent', to: 'users/pages#mail_sent', as: :user_mail_sent

  # 開発環境でのメール確認用
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
