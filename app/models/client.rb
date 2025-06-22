# == Schema Information
#
# Table name: clients(クライアント情報テーブル)
#
#  id                                                                                          :bigint           not null, primary key
#  birthday(生年月日)                                                                          :date             not null
#  birthplace(出生地（都道府県など）)                                                          :string
#  blood_type(血液型 0=A型, 1=B型, 2=O型, 3=AB型, 4=不明(unknown))                             :integer
#  fullname(クライアントの名前（ニックネーム可）)                                              :string           not null
#  gender(性別 0=男性(male), 1=女性(female))                                                   :integer          not null
#  marital_status(婚姻状況 0=未婚(single), 1=既婚(married), 2=離婚(divorced), 3=死別(widowed)) :integer
#  memo(自由記述欄)                                                                            :text
#  created_at                                                                                  :datetime         not null
#  updated_at                                                                                  :datetime         not null
#  job_id(職業ID)                                                                              :bigint
#  occupation_id(職種ID)                                                                       :bigint
#  user_id(所有するユーザーID)                                                                 :bigint           not null
#
# Indexes
#
#  index_clients_on_job_id                (job_id)
#  index_clients_on_occupation_id         (occupation_id)
#  index_clients_on_user_id               (user_id)
#  index_clients_on_user_id_and_fullname  (user_id,fullname)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (occupation_id => occupations.id)
#  fk_rails_...  (user_id => users.id)
#
class Client < ApplicationRecord
  belongs_to :user
  belongs_to :job, optional: true
  belongs_to :occupation, optional: true

  # enum定義 - Rails 7の構文
  enum :gender, { male: 0, female: 1 }
  enum :blood_type, { a: 0, b: 1, o: 2, ab: 3, unknown: 4 }
  enum :marital_status, { single: 0, married: 1, divorced: 2, widowed: 3 }

  # バリデーション
  validates :fullname, presence: true
  validates :birthday, presence: true
  validates :gender, presence: true
end
