# コーディング規約

本ドキュメントは Unilo（`sanmeigaku`）リポジトリで採用するコーディング規約をまとめたものです。Rails 8 / Ruby 3.4 / Hotwire を前提とします。

## 1. 全体方針

- **Rails Omakase**（`rubocop-rails-omakase`）をベースラインとして採用する。差分は `.rubocop.yml` で上書きする。
- **YAGNI**: 将来のために抽象化を先回りしない。3 つ似たコードがあっても、必要になるまで共通化しない。
- **既存のスタイルを優先**: 既存ファイルを編集するときは、その周辺の流儀に合わせる。
- **コメントは「なぜ」を書く**: 何をしているかは命名で伝える。コメントは仕様の背景（算命学のルール等）や、コードからは読み取れない制約のみ書く。
- **コミットメッセージ / UI 文言 / モデルコメントは日本語可**（既存に合わせる）。

## 2. Ruby スタイル（`.rubocop.yml` から派生する規約）

| ルール | 設定 | 例 |
|---|---|---|
| 文字列リテラル | シングルクォート | `'foo'`（補間が必要なときのみ `"#{x}"`） |
| 配列リテラル内のスペース | なし | `[1, 2, 3]`（`[ 1, 2, 3 ]` は NG） |
| その他 | Rails Omakase 準拠 | 2スペースインデント / 80–120 桁 / メソッドは小文字スネークケース |

- `frozen_string_literal: true` マジックコメントは **必須にしない**（Devise の initializer 以外では概ね未使用）。新規ファイルで付けても付けなくてもよい。
- `freeze` は **定数**（モジュール内の MESSAGES、定数ハッシュなど）には積極的に付ける。
- メソッドの **戻り値が複数になるとき** は `return a, b, c`（ハッシュ返しが望ましいが、既存サービスでは tuple 返却が多い）。

### コミット前に必ず実行

```bash
bin/rubocop                 # 違反がないことを確認
bin/rubocop -A              # 自動修正できる箇所を反映
```

## 3. Rails 規約

### Controller

- **基底クラスは `ApplicationController`**。認証は `before_action :authenticate_user!` が自動適用済み（`skip_authenticate?` 例外）。新規コントローラで認証を外す場合は `skip_before_action :authenticate_user!, only: [...]` を明示する。
- **Strong Parameters**: `xxx_params` メソッドにまとめる。`params.require(:foo).permit(...)` 形式。
- **`render` vs `redirect_to`**: 失敗時のフォーム再表示は `render :new, status: :unprocessable_entity`（[fortune_records_controller.rb:21](app/controllers/fortune_records_controller.rb)）の形を推奨。`save!` を使うと例外が出て 500 になるため、フォーム再描画したいときは `save`（非破壊）+ `status: :unprocessable_entity` を使う。
- **クエリ最適化**: `FortuneAnalysis` のように年月日柱 + stem + branch + 蔵干（first/second/third_stem）まで連鎖する場合、`preload` でツリーごと読み込む（[clients_controller.rb:13–17](app/controllers/clients_controller.rb)）。
- **インスタンス変数の数を増やしすぎない**: 命式系のコントローラはどうしても多くなるが、必要なら View モデル / Decorator を検討する。

### Model

- 先頭の `# == Schema Information` ブロックは **`annotaterb` が自動更新する**。手で書き換えない。マイグレーション後に `bin/rails annotaterb models` で再生成可能。
- **enum**: Rails 7 構文 `enum :gender, { male: 0, female: 1 }` を使う。enum 列の整数値はマイグレーションコメントで明示する（[db/schema.rb](db/schema.rb) の `clients.gender` 等を参照）。
- **enum prefix**: 同じシンボル（例: `:other`）が複数 enum で重複するときは `prefix: true` を付ける（[fortune_record.rb:35](app/models/fortune_record.rb) を参照）。
- **アソシエーション**: 命式系は同一テーブルへの複数 FK が多いので `class_name:` + `foreign_key:` を明示する。
- **バリデーション**: `presence` は明示的に書く。`null: false` の DB 制約だけに頼らない。
- **ActiveHash の静的マスタ** はテーブル不要のデータ（都道府県、月入日、料金プラン等）に限定する。**ユーザが更新する可能性のあるデータは ActiveRecord** にする。

### Service オブジェクト

- 命式計算のような **副作用を持たない純粋計算** は `app/services/` 配下の単一クラスにする。
- 命名は `〜Calculator` / `〜Wrapper` / `〜BasicResults` 等、役割が読めるものに。
- **クラスメソッド `self.call(...)`** が現在の慣習（`YangChartCalculator.call(...)`、`TenStarsRelationCalculator.call(...)`）。新規サービスはこれに合わせる。
- 引数が 5 つを超える場合は **位置引数ではなくキーワード引数 or パラメータオブジェクト**（`FortuneAnalysisCalculateWrapper` の `calculate_params` ハッシュ方式）を検討する。

### View

- **ERB**。`<%= ... %>` の中で複雑な計算をしない → ヘルパ or Decorator に切り出す。
- **部分テンプレート**は機能ごとに `_xxx.erb` を切る（`app/views/fortune_analysis/` 参照）。
- **Turbo Streams** は `xxx.turbo_stream.erb` の拡張子で（[fortune_analysis/calculate.turbo_stream.erb](app/views/fortune_analysis/calculate.turbo_stream.erb)）。
- **i18n**: 日本語文言でも、再利用される可能性があるものは `config/locales/ja.yml` に置く。一度きりの UI 文言は直接書いてよい。
- **HTML エスケープ**: `html_safe` の使用は、信頼できる定数文字列に限る。動的入力には絶対使わない。

### Helper / Lib

- `app/helpers/` は View 専用。ロジックを置く場所ではない。
- `lib/` 配下に置くのは「Rails 文脈に依存しない / Rails 全体で読み込みたい」コード。算命学の鑑定文言を YAML から読み出す `PhaseMethodText` / `TenStarDirection` / `TenStarSynergy` が現状の例。

### Migration

- 列に**コメントを必ず書く**（特に enum、外部キー、業務上意味のあるカラム）。`db/schema.rb` にも反映される。
- `null: false` を可能な限り付ける。
- 既存データに不整合が出るマイグレーションを書くときは **データ更新マイグレーション**（`20250622095932_update_existing_subscriptions_with_plan_id.rb` のような）を別ファイルとして用意する。

### Routes

- 機能ごとにコメントで区切る（[config/routes.rb](config/routes.rb) 参照）。
- ネストは 1 段まで。深くなるなら shallow ネストを検討。
- 動詞付きエンドポイントは `resources :xxx do member do ... end end` で表現する（`subscriptions#cancel` 等）。

## 4. JavaScript（Importmap + Stimulus + Turbo）

- **ビルド不要**。新規モジュールは `app/javascript/` 配下に置き、`config/importmap.rb` に `pin` を追加。
- **Stimulus controller** は `app/javascript/controllers/xxx_controller.js` に。ファイル名と data-controller 属性を一致させる。
- **Turbo イベント**: `turbo:load` を主に listen（[app/javascript/stripe_subscription.js](app/javascript/stripe_subscription.js)）。`DOMContentLoaded` だけだと SPA 的なナビゲーションで発火しないので併用する。
- 直接 DOM API を叩いてよいが、複雑になるなら Stimulus controller を切る。
- **Stripe Elements** の card element は再マウント前に `unmount()` する（`stripe_subscription.js` の手法）。

## 5. CSS / アセット

- 機能ごとに `app/assets/stylesheets/xxx.css` を分ける。
- グローバル / リセットは `application_reset.css` と `application.css`。
- `application.css` から各機能 CSS を `@import` するか、`<%= stylesheet_link_tag :app %>` でまとめる。
- **クラス命名**: kebab-case（`signed-in`, `app-container`, `side-menu` 等の既存ルール）。BEM などのルールは未採用。

## 6. テスト

- **Minitest**（Rails デフォルト）+ Capybara + Selenium。RSpec は使わない。
- ファイル名は `xxx_test.rb`。
- **fixture** は `test/fixtures/*.yml`。算命学マスタは複雑なため必要最小限のレコードのみ。
- **モデルテスト**は `test/models/` に揃える（valid? の確認、enum、関連等）。
- **コントローラ／システムテスト**は CI で `bin/rails db:test:prepare test test:system` の形で実行される。
- 算命学計算ロジックを変更する場合は **入力（生年月日 / 性別）と期待される出力（干支ID / 星）を fixture でカバー**する。

## 7. セキュリティ

- **Brakeman**：CI で実行。新規 PR で警告が増えないこと。
- **importmap audit**：JS 依存の脆弱性。
- **CSRF**: Webhook 以外で `skip_before_action :verify_authenticity_token` を**書かない**。
- **Strong Parameters**：必ず使う。属性をホワイトリスト化。
- **Mass-assignment 対策の `current_user` スコープ**：`current_user.clients.find(params[:id])` のように自分のリソースのみ取得する（IDOR 防止）。`Client.find(...)` を直接使う場合は意図を要確認。
- **シークレット**：`config/credentials.yml.enc` に。環境変数で渡せるものは ENV に。

## 8. annotaterb と git の運用

- マイグレーション後に schema コメントが書き換わるため、レビュー時には **schema コメントの差分を別途確認**する（重要な業務的意味が `comment:` に書いてあることが多い）。
- `bin/rails annotaterb models` は必要に応じて手動実行可能。

## 9. プルリクエスト

- 1 PR は 1 関心事に絞る。
- PR 説明には **「なぜ」** を書く（仕様の意図、リファクタの理由など）。
- CI（brakeman / importmap audit / rubocop / tests）が全て緑であること。
- 算命学計算の変更を含む場合は、**鑑定結果が変わる可能性のある条件**（特定の生年月日範囲）を PR 説明に明記する。
