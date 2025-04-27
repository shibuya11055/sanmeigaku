class Job < ApplicationRecord
  # アソシエーション
  has_many :clients, dependent: :nullify

  # バリデーション
  validates :name, presence: true, uniqueness: true
end
