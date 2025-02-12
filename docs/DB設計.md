## 命式を保存するテーブル

| `カラム名`                 | `型`      | `説明`              |
|------------------------|----------|-------------------|
| `id`                   | bigint   | 主キー               |
| `birthday`             | date     | 生年月日              |
| `sexagenary_cycle_year_id`   | int   |  年柱の干支ID         |
| `sexagenary_cycle_month_id`  | string   | 月柱の干支ID             |
| `sexagenary_cycle_day_id`  | string   | 日柱の干支ID         |
| `created_at`           | datetime | 作成日時              |
| `updated_at`           | datetime | 更新日時              |

| `インデックス名`                | `カラム`              | `用途・理由`               |
|--------------------------|--------------------|-----------------------|
| `PRIMARY KEY (id)`       | `id`               | 主キー（必須）               |
| `INDEX birthday_eto_idx` | `birthday, eto_id` | 誕生日と干支IDの組み合わせで検索を高速化 |
