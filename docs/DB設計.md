## 命式計算データ

命式（年柱・月柱・日柱）は `Sanmeigaku::NatalChartCalculator` が静的マスタから都度算出する。
命式を保存する `fortune_analyses` テーブルと、旧DBマスタは
`RemoveLegacyCalculationTables` マイグレーションで廃止する。

## DBに保存するデータ

PostgreSQLには、ユーザー・顧客・鑑定カルテ・サブスクリプションなど、利用者の業務データのみを保存する。

- `users`
- `clients`
- `fortune_records`
- `subscriptions`
- `jobs` / `occupations`

五行・干支・星・蔵干・六親などの計算マスタは、`app/models/sanmeigaku/static_data.rb` と
ActiveHashの静的モデルで管理し、DBの参照を必要としない。
