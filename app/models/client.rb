class Client < ApplicationRecord
  belongs_to :user
  belongs_to :job, optional: true
  belongs_to :occupation, optional: true

  # enum定義
  enum gender: { male: 0, female: 1 }
  enum blood_type: { a: 0, b: 1, o: 2, ab: 3, unknown: 4 }
  enum marital_status: { single: 0, married: 1, divorced: 2, widowed: 3 }

  # バリデーション
  validates :fullname, presence: true
  validates :birthday, presence: true
  validates :gender, presence: true
end
