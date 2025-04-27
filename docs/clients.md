## `clients` テーブル

| カラム名 | 型 | 制約・備考 |
|:--|:--|:--|
| id | integer | 主キー |
| user_id | integer | 外部キー (usersテーブル参照)（null不可） |
| fullname | string | クライアントの名前（ニックネーム可）（null不可） |
| birthday | date | 生年月日（null不可） |
| gender | integer | enum: 0=男性(male), 1=女性(female)（null不可） |
| job_id | integer | 外部キー (jobsテーブル参照) |
| occupation_id | integer | 外部キー (occupationsテーブル参照) |
| birthplace | string | 出生地（都道府県など） |
| blood_type | integer | enum: 0=A型, 1=B型, 2=O型, 3=AB型, 4=不明(unknown) |
| marital_status | integer | enum: 0=未婚(single), 1=既婚(married), 2=離婚(divorced), 3=死別(widowed) |
| memo | text | 自由記述欄 |
| created_at | datetime | 作成日時 |
| updated_at | datetime | 更新日時 |

---

## `jobs` テーブル

| カラム名 | 型 | 制約・備考 |
|:--|:--|:--|
| id | integer | 主キー |
| name | string | 職業名（例: "会社員"） |
| created_at | datetime | 作成日時 |
| updated_at | datetime | 更新日時 |

---

## `occupations` テーブル

| カラム名 | 型 | 制約・備考 |
|:--|:--|:--|
| id | integer | 主キー |
| name | string | 職業名（例: "会社員"） |
| created_at | datetime | 作成日時 |
| updated_at | datetime | 更新日時 |
