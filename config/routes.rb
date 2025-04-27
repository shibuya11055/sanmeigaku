Rails.application.routes.draw do
  # 自動生成されたルートを削除
  # get "clients/index"
  # get "clients/show"
  # get "clients/new"
  # get "clients/edit"

  # クライアントのリソースルーティングを追加
  resources :clients

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks'
  }

  # ルートパスをクライアント一覧に変更
  root to: 'clients#index'

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
