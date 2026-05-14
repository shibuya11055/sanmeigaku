# 開発ガイド

Unilo (`sanmeigaku`) をローカルで動かし、開発／テスト／デプロイするための手順をまとめます。

## 1. 前提

- macOS / Linux（Apple Silicon 動作確認済み）
- Ruby 3.4.1（`.ruby-version`、`rbenv` / `asdf` / `mise` 等で固定）
- PostgreSQL 14+（`brew install postgresql@16` 推奨）
- Google Chrome（システムテストで使用）
- Stripe CLI（決済機能を触る場合）

## 2. 初回セットアップ

```bash
# Ruby & Bundler
ruby -v                          # 3.4.1 であることを確認
gem install bundler

# 依存インストール + DB 作成 + seed + サーバ起動
bin/setup
```

`bin/setup` は内部で以下を行います：

1. `bundle install`
2. `bin/rails db:prepare`
3. `bin/rails log:clear tmp:clear`
4. `bin/rails server`

`bin/setup --skip-server` でサーバ起動を抑制できます。

### マスタデータの投入

算命学の各種マスタ（十干、十二支、60干支、十大主星、十二大従星、対応マッピング）は `db/seeds.rb` に定義されています。**新規 DB を作ったときは必ず seed が必要です**：

```bash
bin/rails db:seed
```

`db:prepare` は seed まで走らせるため、`bin/setup` 経由なら自動的に投入されます。

### Credentials

```bash
EDITOR="vi" bin/rails credentials:edit
```

最低限以下が必要：

```yaml
secret_key_base: <自動生成>
stripe:
  publishable_key: pk_test_xxx
  secret_key: sk_test_xxx
  webhook_secret: whsec_xxx          # stripe CLI 用
  prod_webhook_secret: whsec_yyy     # 本番用
```

`config/master.key` が必要です。`config/credentials.yml.enc` と一緒に既存環境からコピーしてください（git 管理外）。

## 3. 日常コマンド

```bash
# サーバ起動
bin/rails server                 # http://localhost:3000

# Rails console
bin/rails console

# DB
bin/rails db:migrate
bin/rails db:rollback
bin/rails db:seed
bin/rails db:test:prepare        # test 用 DB を schema から再構築

# モデルのスキーマコメント再生成（マイグレーション直後に必要なら）
bin/rails annotaterb models
```

## 4. テスト

```bash
# モデル / コントローラ / etc
bin/rails test

# システムテスト（Capybara + Selenium + Chrome）
bin/rails test:system

# CI と同じ
bin/rails db:test:prepare test test:system
```

- 失敗時のスクリーンショットは `tmp/screenshots/` に保存される（CI もここをアーティファクトとして保存）。
- 算命学の計算ロジック（`app/services/` 配下）は値が変わると鑑定結果に影響するため、**最低限「特定の生年月日 → 特定の干支ID」のリグレッション**が通っている必要があります。fixture (`test/fixtures/*.yml`) に基準データが入っています。

## 5. Lint / 静的解析

```bash
bin/rubocop                      # スタイルチェック
bin/rubocop -A                   # 自動修正

bin/brakeman --no-pager          # Rails 脆弱性スキャン
bin/importmap audit              # JS 依存の脆弱性
```

PR を出す前にすべて緑にすること（CI でもチェックされます）。

## 6. メール開発

開発環境では `letter_opener_web` 経由でメールをブラウザで確認できます：

- 起動中サーバで `http://localhost:3000/letter_opener` にアクセス
- Devise の確認メール、パスワードリセットメール等がここに溜まる

## 7. Stripe（サブスク決済）の開発

### CLI セットアップ

```bash
brew install stripe/stripe-cli/stripe   # macOS
stripe login                            # ブラウザでテストアカウントに認証
```

### Webhook をローカルへ転送

```bash
stripe listen --forward-to localhost:3000/stripe/webhook
```

実行すると `whsec_xxxx` の webhook signing secret が表示されるので、`credentials.stripe.webhook_secret` に保存。

### テストカード

- 成功: `4242 4242 4242 4242`、未来日、任意 CVC
- 認証要求 (3D Secure): `4000 0027 6000 3184`

### 動作確認の流れ

1. ユーザ登録 → ログイン
2. `/subscriptions/new` でクレカ入力
3. `customer.subscription.updated` が `stripe listen` のターミナルに流れる
4. `Subscription` レコードが `status: active` になる

## 8. 2要素認証の確認

1. ログイン後 `/user` 画面 → 「2要素認証を有効化」
2. QR コードを Google Authenticator 等で読み取り
3. 表示されている 6 桁コードを入力 → 有効化
4. ログアウトして再ログインすると `/two_factor_authentication` で TOTP を要求される
5. バックアップコード（10 個）でも代用可能

## 9. デプロイ（Kamal）

本番デプロイは Kamal を使用します（`config/deploy.yml`）。

```bash
# 初回デプロイ
kamal setup

# 通常のデプロイ
kamal deploy

# ロールバック
kamal rollback
```

詳細は `config/deploy.yml` と Kamal 公式ドキュメント (https://kamal-deploy.org) を参照。

### 本番環境変数

以下を Kamal 経由で渡す必要があります：

| 変数 | 用途 |
|---|---|
| `RAILS_MASTER_KEY` | credentials 復号 |
| `BASIC_AUTH_USER` / `BASIC_AUTH_PASSWORD` | サイト全体への HTTP Basic 認証 |
| `SANMEIGAKU_DATABASE_PASSWORD` | 本番 DB パスワード |
| `SANMEIGAKU_DATABASE_URL` | DB 接続文字列（任意） |
| `RAILS_MAX_THREADS` | Puma スレッド数（デフォルト 5） |
| `SOLID_QUEUE_IN_PUMA` | Puma 内に Solid Queue を同居させる場合に設定 |

### Docker イメージ

`Dockerfile` は Kamal 用にチューニング済み（マルチステージ、bootsnap precompile、Thruster + Puma）。**開発用ではない**ので、ローカル開発ではそのまま `bin/rails server` を使ってください。

## 10. ブランチ運用

- `main` がデフォルト / 本番ブランチ
- PR ベースで開発
- マージ前に CI 全緑、レビュー 1 名以上

## 11. トラブルシューティング

### `db:seed` が失敗する

- マスタの順序依存が厳しいです。`db:reset` で完全に作り直すとよい：
  ```bash
  bin/rails db:reset
  ```
  これは **既存データを全削除する** ので、開発 DB のみで実行すること。

### 鑑定結果が変な日付

- `docs/実行えラーになる日付.md` に既知のエッジケースあり：
  - 1928/12/7–31、1933/12/7–31（月番号が 61）
  - 1984/1/1（年番号が 0）
- 上記の日付以外で値が崩れる場合、`LunarCalendarEntry`（月入日）または `YearlyDayNumber`（年表）のデータミスを疑う。

### Stripe webhook が届かない

- `stripe listen` が起動しているか確認
- credentials の `webhook_secret` が `stripe listen` の出力した値と一致しているか確認
- Rails 側のログ（`log/development.log`）に `Stripe::SignatureVerificationError` が出ていないか確認

### システムテストが Chrome で失敗する

- Chrome / chromedriver のバージョン不整合が典型。`bundle update selenium-webdriver` で更新を試す。
- CI（GitHub Actions）は `google-chrome-stable` を毎回インストールしている（`.github/workflows/ci.yml`）。

## 12. 参考ドキュメント

- [CLAUDE.md](../CLAUDE.md) — Claude Code 向けプロジェクトガイド
- [docs/ARCHITECTURE.md](ARCHITECTURE.md) — アーキテクチャ
- [docs/CODING_STYLE.md](CODING_STYLE.md) — コーディング規約
- [docs/命式の計算.md](%E5%91%BD%E5%BC%8F%E3%81%AE%E8%A8%88%E7%AE%97.md) — 算命学の計算ロジック
- [docs/60干支分類.md](60%E5%B9%B2%E6%94%AF%E5%88%86%E9%A1%9E.md) — 60干支表
- [docs/月入日表.md](%E6%9C%88%E5%85%A5%E6%97%A5%E8%A1%A8.md) — 月入日データ
- [docs/年表.md](%E5%B9%B4%E8%A1%A8.md) — 年表データ
