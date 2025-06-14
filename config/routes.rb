Rails.application.routes.draw do
  # 自動生成されたルートを削除
  # get "clients/index"
  # get "clients/show"
  # get "clients/new"
  # get "clients/edit"

  # クライアントのリソースルーティングを追加
  resources :clients

  # ユーザー管理のルーティング（単数リソース）
  resource :user, only: [:show, :edit, :update]

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    unlocks: 'users/unlocks',
    sessions: 'users/sessions'
  }

  # 2要素認証のルーティング
  get 'two_factor/setup', to: 'two_factor#setup', as: :setup_two_factor
  post 'two_factor/enable', to: 'two_factor#enable', as: :enable_two_factor
  delete 'two_factor/disable', to: 'two_factor#disable', as: :disable_two_factor

  # 2要素認証ログイン
  get 'two_factor_authentication', to: 'two_factor_authentication#show'
  post 'two_factor_authentication', to: 'two_factor_authentication#verify'

  # ルートパスをクライアント一覧に変更
  root to: 'clients#index'

  # サブスクリプション管理
  resources :subscriptions, except: [:show] do
    member do
      patch :cancel
      patch :resume
    end
  end

  # 他のルーティング
  get 'fortune_analysis', to: 'fortune_analysis#index'
  post 'fortune_analysis/calculate', to: 'fortune_analysis#calculate'

  # メール送信完了画面
  get 'users/mail_sent', to: 'users/pages#mail_sent', as: :user_mail_sent

  # 開発環境でのメール確認用
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Stripe Webhook受信用のルート
  post 'stripe/webhook', to: 'stripe_webhooks#receive'
end
