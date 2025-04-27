class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # アソシエーション
  has_many :clients, dependent: :destroy

  # fullnameを必須項目として検証
  validates :fullname, presence: true
end
