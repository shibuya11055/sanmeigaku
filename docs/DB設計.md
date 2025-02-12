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
