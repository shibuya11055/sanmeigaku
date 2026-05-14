# AGENTS.md

このファイルは、本リポジトリで作業する Codex (Codex.com/code) 向けのガイダンスです。

## プロジェクト概要

**Unilo**（リポジトリ名: `sanmeigaku`）は、算命学（東洋占星術の一種）を扱う占い師向けの SaaS アプリケーションです。占い師は顧客（クライアント）情報を登録し、生年月日から算命学の各種命式を自動算出して鑑定に利用、鑑定結果をカルテ（`fortune_records`）として記録します。利用は Stripe による月額サブスクリプションで提供されます。

- **Rails モジュール名**: `Unilo`（`config/application.rb`）
- **ブランド名 / 表示名**: Unilo
- **デフォルトロケール**: `ja`、タイムゾーン: `Tokyo`

## 技術スタック

| レイヤ | 採用技術 |
|---|---|
| 言語 | Ruby 3.4.1 (`.ruby-version`) |
| フレームワーク | Rails 8.0.1 |
| DB | PostgreSQL（`pg` gem） |
| アプリサーバ | Puma + Thruster（HTTP キャッシュ / 圧縮） |
| アセット | Propshaft（CSS）+ Importmap（JS、ビルド不要） |
| フロント | Hotwire（Turbo + Stimulus）|
| 認証 | Devise + devise-i18n + 2要素認証（`rotp` + `rqrcode`） |
| 決済 | Stripe（`stripe` gem） |
| 静的マスタ | `active_hash`（Prefecture / Plan / LunarCalendarEntry / YearlyDayNumber / CycleMapping / ElementRelation） |
| バックグラウンド | Solid Queue / Solid Cache / Solid Cable |
| デプロイ | Kamal（Docker コンテナ） |
| Lint | RuboCop（`rubocop-rails-omakase` ベース） |
| 静的解析 | Brakeman、`bin/importmap audit` |
| テスト | Rails 標準 Minitest + Capybara + Selenium |
| モデル注釈 | annotaterb（schema 情報をモデル先頭に追記） |
| 開発用メール | letter_opener_web（`/letter_opener`） |

## クイックリファレンス

### よく使うコマンド

```bash
# 初期セットアップ
bin/setup                       # bundle install + db準備 + ログクリア + サーバ起動

# 開発サーバ
bin/rails server                # http://localhost:3000

# DB
bin/rails db:create db:migrate
bin/rails db:seed               # 算命学マスタ（十干・十二支・60干支等）を投入
bin/rails db:reset              # drop + setup（破壊的、確認必須）

# テスト
bin/rails test                  # モデル/コントローラ等のユニットテスト
bin/rails test:system           # システムテスト（要 chrome）
bin/rails db:test:prepare test test:system  # CI と同じコマンド

# Lint / セキュリティ
bin/rubocop                     # スタイルチェック
bin/rubocop -A                  # 自動修正
bin/brakeman --no-pager         # Rails 脆弱性スキャン
bin/importmap audit             # JS 依存の脆弱性チェック

# モデル注釈の再生成（schema コメント更新）
bin/rails annotaterb models

# Stripe webhook をローカルへ転送（開発時）
stripe login
stripe listen --forward-to localhost:3000/stripe/webhook

# 開発時の送信メール確認
# http://localhost:3000/letter_opener
```

### CI（`.github/workflows/ci.yml`）

PR / `main` への push で以下を実行：

1. `bin/brakeman --no-pager`
2. `bin/importmap audit`
3. `bin/rubocop -f github`
4. `bin/rails db:test:prepare test test:system`（PostgreSQL サービスコンテナで実行）

PR 前にローカルで上記 4 つを通すこと。

## ディレクトリ構成（要点）

```
app/
  controllers/     # 標準的な Rails Controller。app全体で require_authentication（後述）
  models/          # AR モデル + ActiveHash モデル（静的マスタ）
    concerns/      # PhaseRelationship（十二支関係性）, StemConst（干合定数）
  services/        # 算命学計算ロジック（Calculator 系）
  views/           # ERB テンプレート
  javascript/      # Stimulus controllers + サイドメニュー + Stripe Elements
  assets/stylesheets/  # 機能ごとに分割（fortune_analysis.css 等）
config/
  routes.rb
  locales/         # ja.yml / en.yml / devise.ja.yml 等
  phase_method.yml ten_star_direction.yml ten_star_synergy.yml  # 鑑定文言データ
db/
  migrate/         # マイグレーション
  schema.rb
  seeds.rb         # 算命学マスタを投入
docs/              # ドメイン知識 / 設計メモ（算命学のルール等）
lib/
  phase_method_text.rb ten_star_direction.rb ten_star_synergy.rb  # YAML 文言を読むヘルパクラス
  tasks/           # rake tasks
test/              # Minitest
```

## ドメイン知識（算命学）

このアプリの中核は **生年月日から算命学の命式を算出する** ロジックです。Codex が ロジックを変更する際は、以下のドキュメントを必ず参照してください：

- [docs/命式の計算.md](docs/%E5%91%BD%E5%BC%8F%E3%81%AE%E8%A8%88%E7%AE%97.md) — 年・月・日番号の算出ルール、宿命図・陽占図の作成手順
- [docs/60干支分類.md](docs/60%E5%B9%B2%E6%94%AF%E5%88%86%E9%A1%9E.md) — 60干支 + 天中殺の対応表
- [docs/十二支の中に含まれる気.md](docs/%E5%8D%81%E4%BA%8C%E6%94%AF%E3%81%AE%E4%B8%AD%E3%81%AB%E5%90%AB%E3%81%BE%E3%82%8C%E3%82%8B%E6%B0%97.md) — 蔵干（藏干）テーブル
- [docs/月入日表.md](docs/%E6%9C%88%E5%85%A5%E6%97%A5%E8%A1%A8.md) — 月入日（節入日）データ（1925–2044）
- [docs/年表.md](docs/%E5%B9%B4%E8%A1%A8.md) — 各月の最初の日番号テーブル
- [docs/DB設計.md](docs/DB%E8%A8%AD%E8%A8%88.md)、[docs/必要なマスタ.md](docs/%E5%BF%85%E8%A6%81%E3%81%AA%E3%83%9E%E3%82%B9%E3%82%BF.md) — マスタ設計
- [docs/clients.md](docs/clients.md) — `clients` テーブル定義
- [docs/実行えラーになる日付.md](docs/%E5%AE%9F%E8%A1%8C%E3%81%88%E3%83%A9%E3%83%BC%E3%81%AB%E3%81%AA%E3%82%8B%E6%97%A5%E4%BB%98.md) — 既知のエッジケース（1928/12, 1933/12, 1984/1）

### 主要ドメインモデル

| モデル | 役割 |
|---|---|
| `Element` | 五行（木火土金水） |
| `Stem` | 十干（甲乙…癸） |
| `Branch` | 十二支（子丑…亥）。蔵干として `first/second/third_stem` を持つ |
| `SexagenaryCycle` | 60干支（Stem × Branch + 天中殺） |
| `FortuneAnalysis` | 生年月日 → 年柱・月柱・日柱の 60 干支ID。`birthday` を一意キーとして用いる |
| `TenMajorStar` | 十大主星（貫索星・石門星・…・玉堂星） |
| `TwelveSubStar` | 十二大従星 |
| `StemTenStarMapping` | 日干気 × 他気 → 十大主星 |
| `StemTwelveStarMapping` | 日干 × 十二支 → 十二大従星 |
| `StemLineage` | 六親法（家族関係の干推定） |
| `User` / `Client` / `FortuneRecord` / `Subscription` | 業務系 |
| `Plan` / `Prefecture` / `LunarCalendarEntry` / `YearlyDayNumber` / `CycleMapping` / `ElementRelation` | ActiveHash 製の静的マスタ |

### サービス層（`app/services/`）

算命学の計算は単体クラスに分離し、コントローラから合成して使う。

| クラス | 計算する内容 |
|---|---|
| `FortuneAnalysisBasicResults` | 蔵干、十二大従星（年/月/日）、異常干支、各種中殺、干合 |
| `FortuneAnalysisCalculateWrapper` | 各 Calculator のファサード（DI 用） |
| `YangChartCalculator` | 陽占図の十大主星・十二大従星マトリクス |
| `TenStarsRelationCalculator` | 陽占の星同士の関係 |
| `StemLineageCalculator` | 六親法（家族の干） |
| `NumerologicalCalculator` | 数理法（数の解釈）|
| `PhaseMethodCalculator` | 位相法 |
| `YearlyFortuneCalculator` / `MajorFortuneCalculator` | 年運 / 大運 |
| `RelationshipCalculator` | 十干十二支間の関係性 |

## アーキテクチャ上の重要な決まり

### 認証フロー

- `ApplicationController` で `before_action :authenticate_user!` を**全コントローラに**適用。
- 認証スキップは `skip_authenticate?`（Devise の認証関連ページ）または明示的な `skip_before_action :authenticate_user!`（`PagesController#lp` / `#terms_of_service` / `#privacy_policy`、`StripeWebhooksController`、`TwoFactorAuthenticationController`）で行う。
- 本番では `Rails.env.production?` のとき HTTP Basic 認証を全リクエストに要求（`BASIC_AUTH_USER` / `BASIC_AUTH_PASSWORD` 環境変数）。
- 2要素認証は ROTP ベースの TOTP（`User#enable_two_factor!` / `verify_otp` / バックアップコード）。`TwoFactorAuthenticationController` がログイン中間ステップを担当。

### Stripe webhook

- `POST /stripe/webhook` は CSRF / 認証両方をスキップ。
- 署名検証は環境ごとに `credentials.stripe.webhook_secret` / `credentials.stripe.prod_webhook_secret` を使い分け（`StripeWebhooksController#receive` 参照）。
- 取り扱いイベントは現状 `customer.subscription.updated` のみ。

### Devise カスタマイズ

- `users/registrations` `users/passwords` `users/confirmations` `users/unlocks` `users/sessions` をそれぞれ独自コントローラに差し替え（`app/controllers/users/`）。
- `fullname` をサインアップ / 更新の許可パラメータに追加（`ApplicationController#configure_permitted_parameters`）。
- 確認メール（confirmable）有効。

### 静的マスタは ActiveHash

`Prefecture`（都道府県47件）、`Plan`（料金プラン）、`LunarCalendarEntry`（月入日 1925-2044）、`YearlyDayNumber`、`CycleMapping`（60干支）、`ElementRelation`（五行関係）は **DB を持たず ActiveHash で定義**。値はコード（モデルファイル）で管理する。値を更新する場合はコードを編集する。

### アセット戦略

- ビルドツールなし。`importmap-rails` でブラウザ側 ESM を解決。新しい JS を追加するときは `config/importmap.rb` に `pin` を追加。
- CSS は Propshaft 経由でそのまま配信。`app/assets/stylesheets/` 配下に機能ごとファイルを置き、`application.css` で `@import` する形が現状の慣習。

### モデル注釈

`annotaterb` を導入済み。マイグレーションを実行すると、自動的に対応モデル先頭の `# == Schema Information` ブロックが更新される（`.annotaterb.yml`）。**マイグレーション後はモデル先頭のコメントが変わるので、レビュー時は schema コメントの変更を別途確認**。

## コーディング上の注意

詳細は [docs/CODING_STYLE.md](docs/CODING_STYLE.md) を参照。要点は以下。

- **文字列リテラル**: シングルクォート（`Style/StringLiterals: single_quotes`）。
- **配列リテラルの内側スペース**: なし（`Style/SpaceInsideArrayLiteralBrackets: no_space`）。
- **コメント / コミット / UI 文言**: 日本語可（既存コードに合わせる）。
- **enum 定義**: Rails 7 構文（`enum :gender, { male: 0, female: 1 }`）を使う。
- **強い破壊メソッド（`save!` / `update!` / `destroy!`）**: 既存コントローラでは多用されているが、`render :new` などの「失敗時にフォームを再表示」したい箇所では破壊メソッドだと例外で 500 になる。新規追加時は要注意（既存実装の `clients_controller.rb#create` は `save!` を使っているが、`fortune_records_controller.rb#create` は `save` を使い `status: :unprocessable_entity` を返している。後者がより望ましい挙動）。
- **N+1 対策**: `FortuneAnalysis.preload(...)` のように、年/月/日柱 + 各 stem / branch + 蔵干（first/second/third_stem）まで一括 preload する慣習がある。
- **テスト**: `test/` 配下の Minitest。fixtures は最低限の 60 干支関連が用意済み。

## 環境変数 / Credentials

| 変数 | 用途 |
|---|---|
| `RAILS_MASTER_KEY` | `config/credentials.yml.enc` 復号 |
| `BASIC_AUTH_USER` / `BASIC_AUTH_PASSWORD` | 本番 Basic 認証 |
| `SANMEIGAKU_DATABASE_PASSWORD` / `SANMEIGAKU_DATABASE_URL` | 本番 DB 接続 |
| `RAILS_MAX_THREADS` | Puma スレッド数 / DB プール |
| `SOLID_QUEUE_IN_PUMA` | Puma 内で Solid Queue を走らせる |

`credentials.yml.enc` の中身（既知）:

- `stripe.publishable_key` / `stripe.secret_key`
- `stripe.webhook_secret`（開発）/ `stripe.prod_webhook_secret`（本番）
- `secret_key_base`（Rails 標準）

## ルーティング全体図

```text
GET    /                         pages#lp
GET    /lp                       pages#lp
GET    /terms_of_service         pages#terms_of_service
GET    /privacy_policy           pages#privacy_policy

resources :clients
  resources :fortune_records, only: [:new, :create]
resources :fortune_records, only: [:index, :show, :edit, :update, :destroy]

resource  :user                  # 単数リソース（show/edit/update）

devise_for :users (custom controllers)
GET    /two_factor/setup
POST   /two_factor/enable
DELETE /two_factor/disable
GET    /two_factor_authentication
POST   /two_factor_authentication

resources :subscriptions, except: [:show]
  member: PATCH cancel / PATCH resume

GET    /fortune_analysis         (preview & calc 単体UI)
POST   /fortune_analysis/calculate

POST   /stripe/webhook
GET    /letter_opener            (dev only)
```

## やってはいけないこと

1. **`db/seeds.rb` の干支・天中殺データを根拠なく書き換えない**。算命学のルールに直結する。
2. **`LunarCalendarEntry` / `YearlyDayNumber` / `CycleMapping` の固定データを書き換えない**。鑑定結果が変わる。
3. **`config/master.key` を git に含めない**（`.gitignore` で除外済み）。
4. **`/materials/*` を git に含めない**（同上、書籍画像など権利物）。
5. **Stripe 関連を本番キーで実験しない**。`stripe listen` でテストモードを使う。
6. **`bin/rails db:reset` を確認なしで実行しない**。クライアント / 鑑定カルテが消える。

## さらに詳しいドキュメント

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — レイヤ構造、データフロー、命式計算のサービス連携図
- [docs/CODING_STYLE.md](docs/CODING_STYLE.md) — Ruby / Rails / Hotwire / CSS 規約
- [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) — セットアップ手順、テスト、Stripe 開発、デプロイ
