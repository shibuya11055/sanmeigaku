# == Schema Information
#
# Table name: jobs(職業マスタテーブル)
#
#  id                           :bigint           not null, primary key
#  name(職業名（例: "会社員"）) :string           not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_jobs_on_name  (name) UNIQUE
#
class Job < ApplicationRecord
  # アソシエーション
  has_many :clients, dependent: :nullify

  # バリデーション
  validates :name, presence: true, uniqueness: true
end
