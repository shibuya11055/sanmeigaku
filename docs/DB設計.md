## 命式を保存するテーブル

| `カラム名`                 | `型`      | `説明`              |
|------------------------|----------|-------------------|
| `id`                   | bigint   | 主キー               |
| `kanshi_id`            | int      | 対応する干支のID         |
| `birthday`             | date     | 生年月日              |
| `gender`               | string   | 性別                |
| `heavenly_stem_year`   | string   | 年柱の天干             |
| `earthly_branch_year`  | string   | 年柱の地支             |
| `heavenly_stem_month`  | string   | 月柱の天干             |
| `earthly_branch_month` | string   | 月柱の地支             |
| `heavenly_stem_day`    | string   | 日柱の天干             |
| `earthly_branch_day`   | string   | 日柱の地支             |
| `heavenly_stem_hour`   | string   | 時柱の天干（任意）         |
| `earthly_branch_hour`  | string   | 時柱の地支（任意）         |
| `created_at`           | datetime | 作成日時              |
| `updated_at`           | datetime | 更新日時              |

| `インデックス名`                | `カラム`              | `用途・理由`               |
|--------------------------|--------------------|-----------------------|
| `PRIMARY KEY (id)`       | `id`               | 主キー（必須）               |
| `INDEX birthday_eto_idx` | `birthday, eto_id` | 誕生日と干支IDの組み合わせで検索を高速化 |
