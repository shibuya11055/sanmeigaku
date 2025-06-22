# == Schema Information
#
# Table name: occupations(職種マスタテーブル)
#
#  id                               :bigint           not null, primary key
#  name(職種名（例: "エンジニア"）) :string           not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#
# Indexes
#
#  index_occupations_on_name  (name) UNIQUE
#
class Occupation < ApplicationRecord
  # アソシエーション
  has_many :clients, dependent: :nullify

  # バリデーション
  validates :name, presence: true, uniqueness: true
end
