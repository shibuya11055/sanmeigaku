# アーキテクチャ

Unilo（`sanmeigaku`）のアーキテクチャ概要をまとめます。

## 1. システム全体像

```
                     ┌──────────────────────────────┐
   Browser  ────────▶│  Thruster (HTTP cache/asset) │
                     │           │                  │
                     │           ▼                  │
                     │         Puma (Rails 8)       │
                     │  ┌────────────────────────┐  │
                     │  │ Controllers            │  │
                     │  │  ├ Devise (sessions…)  │  │
                     │  │  ├ Clients/Records     │  │
                     │  │  ├ FortuneAnalysis     │  │
                     │  │  ├ Subscriptions       │  │
                     │  │  ├ StripeWebhooks      │  │
                     │  │  └ TwoFactor*          │  │
                     │  ├────────────────────────┤  │
                     │  │ Services (純粋計算)    │  │
                     │  │  Yang/Numerological/…  │  │
                     │  ├────────────────────────┤  │
                     │  │ Models                 │  │
                     │  │  AR + ActiveHash       │  │
                     │  └────────────────────────┘  │
                     │           │                  │
                     └───────────┼──────────────────┘
                                 ▼
                          PostgreSQL
                     (primary + solid_cache/queue/cable schemas)
                                 ▲
                                 │
                          Stripe API ──Webhook──▶ /stripe/webhook
```

- **Thruster** が静的アセット配信 / レスポンス圧縮を担当し、Puma にプロキシ。
- **Puma** はマルチスレッド構成。`SOLID_QUEUE_IN_PUMA=true` のときは Solid Queue supervisor も同じプロセス内で起動。
- **PostgreSQL** は 1 つのインスタンスを共有しつつ、本番は `primary` / `cache` / `queue` / `cable` の 4 つの論理 DB に分けて運用（`config/database.yml`）。

## 2. レイヤ構成

### 2.1 Presentation 層

- **ERB ビュー + Turbo + Stimulus**
- 部分テンプレートで命式の各セクション（陽占図、陰占図、六親、数理法、位相法、年運、大運…）を切り分け（`app/views/fortune_analysis/_*.erb`）。
- Stripe Elements を `app/javascript/stripe_subscription.js` でマウント。
- レイアウトは `application.html.erb` 一枚。ログイン状態でサイドメニュー表示を切り替え（`shared/_side_menu.html.erb`）。

### 2.2 Application 層（Controllers）

- 認証は `ApplicationController` で **オプトアウト方式**（全コントローラに `authenticate_user!`、skip したい所だけ skip）。
- 本番では HTTP Basic 認証も全体に被せる（α/β 期の閲覧制限）。
- 命式系コントローラ（`ClientsController#show` / `FortuneAnalysisController#index`）は、`Sanmeigaku::NatalChartCalculator` で命式を都度算出し、`FortuneAnalysisBasicResults` と `FortuneAnalysisCalculateWrapper` に処理を委譲する。

### 2.3 Domain 層（Models + Services）

- **ユーザ・業務**（DB 永続）: `User` / `Client` / `FortuneRecord` / `Subscription`
- **静的マスタ**（ActiveHash / Ruby値オブジェクト、コード内データ）: `Prefecture` / `Plan` / `LunarCalendarEntry` / `YearlyDayNumber` / `CycleMapping` / `ElementRelation` / `Sanmeigaku::StaticData`
- **Calculator サービス**: 鑑定の各種要素を別クラスに分離（後述）

### 2.4 Infrastructure 層

- **PostgreSQL** (`pg`)
- **Solid Cache / Queue / Cable** で外部 Redis / Sidekiq を不要にしている
- **Stripe API**（同期 + Webhook）
- **メール**: Devise の確認メールとパスワード再設定メールは使用しない

## 3. データモデル

主要テーブルと関係：

```
User ──< Client ──< FortuneRecord
  │
  └──< Subscription (Stripe 連動)

Client.birthday ──▶ Sanmeigaku::NatalChartCalculator
                         │
                         ├─ Sanmeigaku::StaticData（干・支・60干支・星・六親）
                         └─ LunarCalendarEntry / YearlyDayNumber（ActiveHash）
```

- **`Sanmeigaku::StaticData`** は干・支・60干支・星・六親・蔵干を値オブジェクトとして保持する。
- **`Sanmeigaku::NatalChartCalculator`** は生年月日から年柱・月柱・日柱をDBへ保存せずに算出する。

### 主な Enum

| モデル.列 | 値 |
|---|---|
| `Client.gender` | `male: 0, female: 1` |
| `Client.blood_type` | `a/b/o/ab/unknown` |
| `Client.marital_status` | `single/married/divorced/widowed` |
| `FortuneRecord.category` | `love/work/health/family/money/human_relation/study/other` |
| `FortuneRecord.consultation_method` | `face_to_face/video_call/phone/chat/mail/other`（`prefix: true`）|
| `Subscription.status` | `incomplete/incomplete_expired/trialing/active/past_due/canceled/unpaid` |

## 4. 算命学の計算フロー

`ClientsController#show` または `FortuneAnalysisController#index` から、以下の順で計算が走ります。

```
入力: Client.birthday (生年月日), Client.gender (性別)
   │
   ▼
[1] Sanmeigaku::NatalChartCalculator.call(...)     ← 年/月/日柱を静的データから算出
   │
   ▼
[2] FortuneAnalysisBasicResults.new(...)           ← 共通の基礎データ
   │   ├ birth_qi              # 蔵干（藏干）
   │   ├ branch_and_stem_sub_star  # 十二大従星（年/月/日）
   │   ├ stem_unions           # 干合
   │   ├ abnormals             # 異常干支
   │   └ birth_voids           # 生日中殺・生月中殺 etc.
   │
   ▼
[3] FortuneAnalysisCalculateWrapper.new(...)       ← 各 Calculator の合成ファサード
   │   ├ stem_lineage          → StemLineageCalculator     # 六親法
   │   ├ numerological…        → NumerologicalCalculator   # 数理法
   │   ├ phase_method          → PhaseMethodCalculator     # 位相法
   │   ├ yearly_fortune        → YearlyFortuneCalculator   # 年運
   │   └ major_fortune         → MajorFortuneCalculator    # 大運
   │
   ▼
[4] YangChartCalculator.call(...)                  ← 陽占図（十大主星・十二大従星のマトリクス）
[5] TenStarsRelationCalculator.call(...)           ← 陽占の星同士の関係
   │
   ▼
View へ受け渡し（@変数として）
```

### 蔵干の計算（`FortuneAnalysisBasicResults#birth_qi`）

1. **月入日からの経過日数** を計算（`LunarCalendarEntry.lunar_birth_day` + `lunar_birth_last_day_previous_month` / `lunar_birth_day_previous_month`）
2. 経過日数を **`Sanmeigaku::StaticData::Branch` の蔵干期間** と比較し、どの蔵干に該当するか判定

### 月入日（節入日）データ

`LunarCalendarEntry`（`app/models/lunar_calendar_entry.rb`）に 1925〜2044 年分の月入日が `[Jan, Feb, …, Dec]` 配列で格納されています。**算命学では暦の始まりが新月ではなく節分の翌日（立春周辺）** なので、2 月の月入日（4〜5 日頃）が年の始まりとなります。

## 5. 認証アーキテクチャ

```
                ┌──────────────┐
  Sign In Form  │ DeviseSession│ 
       │        │ Controller   │
       ▼        └──────────────┘
   POST /users/sign_in
       │
       │ valid password?
       ▼
   ┌─────────────────────────────┐
   │ User#two_factor_enabled? ?  │
   └────────────┬────────────────┘
        Yes     │     No
                ▼
   session[:two_factor_user_id] = user.id
   redirect_to /two_factor_authentication
                │
                ▼
   POST /two_factor_authentication
   ┌─────────────────────────────┐
   │ verify_otp(code) or         │
   │ verify_backup_code(code)    │
   └────────────┬────────────────┘
                ▼
   sign_in(user) + clear session key
                │
                ▼
       認証完了 / アプリ画面へ
```

- TOTP は `rotp` gem、QR コードは `rqrcode`。
- バックアップコードは 10 個発行、使い切り。
- 詳細実装は `User` モデル / `TwoFactorAuthenticationController` / `TwoFactorController`。

## 6. サブスクリプション / 決済

### 新規加入

```
User → /subscriptions/new
   │
   ▼ POST /subscriptions
   │
   ├─ Stripe::Customer.create
   ├─ Stripe::Price (既存検索 or 作成)
   ├─ Stripe::Subscription.create
   └─ Subscription レコード作成（status=active/incomplete...）
```

### 解約・再開

- `cancel!`：Stripe 側で `cancel_at_period_end = true`、DB は `status=canceled` + `end_date` を即時更新
- `resume!`：Stripe 側で `cancel_at_period_end = false`、DB は `status=active` + `end_date=nil`

### Webhook

- `POST /stripe/webhook`（CSRF / 認証スキップ）
- 署名検証は `Stripe::Webhook.construct_event`
- 現状処理しているイベント: `customer.subscription.updated`
- Stripe が真実のソース。`subscription_obj['status']` / `ended_at` を DB に反映。

### Plan の管理

`Plan` は ActiveHash モデル（[app/models/plan.rb](../app/models/plan.rb)）。現状 1 件のみ（月額 4980 円）。価格変更はコード変更 + デプロイ。

## 7. アセット / フロントエンド

```
                     <%= javascript_importmap_tags %>
                                │
                                ▼
                       config/importmap.rb
            ┌───────────────┬────────────┬─────────────────┐
            │               │            │                 │
   @hotwired/turbo-rails  controllers/  stripe_subscription  stripe (CDN)
                            │
                            ▼
                  app/javascript/controllers/*.js
                        (Stimulus)
```

- **ビルドステップなし** = importmap で ESM 解決。
- **Stimulus controllers** は `app/javascript/controllers/` 配下に置けば `pin_all_from` で自動 pin。
- **CSS** は Propshaft でそのまま配信。`<%= stylesheet_link_tag :app %>` は `app/assets/stylesheets/application.css` をマニフェストとして使う。

## 8. 国際化

- デフォルトロケール `ja`（`config/application.rb`）。
- Devise の i18n は `devise-i18n` gem + `config/locales/devise.ja.yml` / `devise.views.ja.yml`。
- アプリ独自の文言は `config/locales/ja.yml`。
- 算命学の鑑定文章（星の特徴文・運気の説明等）は **巨大なので別 YAML** に分離：
  - `config/phase_method.yml`（位相法の解説）
  - `config/ten_star_direction.yml`（十大主星の方向別解説）
  - `config/ten_star_synergy.yml`（十大主星間の相性）
  - 読み出しは `lib/phase_method_text.rb` などのラッパクラス経由。

## 9. デプロイ

### Kamal + Docker

- `Dockerfile` はマルチステージビルド（base / build / final）。`USER 1000:1000` で非 root 実行。
- `kamal deploy` で Docker イメージビルド → サーバへ転送 → 切り替え。
- DB マイグレーションは `bin/docker-entrypoint`（Dockerfile 参照）で起動時に実行。

### 環境分離

| 環境 | Basic 認証 | Stripe | Mail |
|---|---|---|---|
| development | なし | テストキー | letter_opener |
| test | なし | – | – |
| production | あり（`BASIC_AUTH_*`） | 本番キー | – |

## 10. 既知の課題 / 改善余地

### 命式計算とDB

`FortuneAnalysisController` と `ClientsController` の計算経路は、`Sanmeigaku::NatalChartCalculator` と
`Sanmeigaku::StaticData` を使って命式を算出する。年柱・月柱・日柱、蔵干、星、年運・大運に
必要な静的マスタはRubyの値オブジェクトとして保持され、鑑定画面の表示時に計算用DBテーブルを参照しない。

旧 `fortune_analyses` と算命学マスタテーブルは、`RemoveLegacyCalculationTables` マイグレーションで削除する。
事前生成・DB補正用の旧計算APIと `db:seed` の命式生成処理も廃止した。

月入日マスタの前後年が存在しない境界日（1925年1月、2044年12月の一部）は、
不完全な計算を続行せず、画面に対応範囲の案内を表示する。
これは対応範囲を機械的に狭めるのではなく、対応方針3（画面で案内する）を採用したもの。

- **コントローラのインスタンス変数が肥大**：`ClientsController#show` と `FortuneAnalysisController#index` でほぼ同じインスタンス変数群を組み立てている。Decorator または ViewModel への抽出余地あり。
- **`StripeWebhooksController` の対応イベントが少ない**：`invoice.payment_failed` / `customer.subscription.deleted` 等の追加検討。
- **テストカバレッジ**：算命学計算サービスの直接テストが薄い。Calculator 単体テストを増やすのが望ましい。
- **`Plan` が ActiveHash**：今後プランを増やすなら AR 化 + 管理画面が必要。
- **アセットの分割**：CSS が機能ごとに分かれているが、`application.css` のマニフェストとしての位置づけが不明瞭。CSS-in-JS や Tailwind 等への移行は別議論。

## 11. 関連ドキュメント

- [CLAUDE.md](../CLAUDE.md)
- [docs/DEVELOPMENT.md](DEVELOPMENT.md)
- [docs/CODING_STYLE.md](CODING_STYLE.md)
- [docs/命式の計算.md](%E5%91%BD%E5%BC%8F%E3%81%AE%E8%A8%88%E7%AE%97.md)
- [docs/DB設計.md](DB%E8%A8%AD%E8%A8%88.md)
- [docs/必要なマスタ.md](%E5%BF%85%E8%A6%81%E3%81%AA%E3%83%9E%E3%82%B9%E3%82%BF.md)
