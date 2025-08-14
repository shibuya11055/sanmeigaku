# == Schema Information
#
# Table name: fortune_records
#
#  id                                    :bigint           not null, primary key
#  amount(占いの金額)                    :integer          not null
#  category(相談内容カテゴリ(enum))      :integer          not null
#  consultation_method(相談手段(enum))   :integer          not null
#  content(占いのカルテ（テキスト情報）) :text             not null
#  end_at(占い終了日時)                  :datetime         not null
#  start_at(占い開始日時)                :datetime         not null
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  client_id(クライアントID（外部キー）) :bigint           not null
#
# Indexes
#
#  index_fortune_records_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#

class FortuneRecord < ApplicationRecord
  belongs_to :client

  enum :category, {
    love: 0,
    work: 1,
    health: 2,
    family: 3,
    money: 4,
    human_relation: 5,
    study: 6,
    other: 7
  }

  enum :consultation_method, {
    face_to_face: 0,
    video_call: 1,
    phone: 2,
    chat: 3,
    mail: 4,
    other: 5
  }, prefix: true

  validates :start_at, :end_at, :amount, :content, :category, :consultation_method, presence: true
  validate :start_at_must_be_before_end_at

  def start_at_must_be_before_end_at
    if start_at.present? && end_at.present? && start_at >= end_at
      errors.add(:start_at, 'は終了日時より前でなければなりません')
    end
  end

  def category_label
    I18n.t("activerecord.attributes.fortune_record.categories.#{category}")
  end

  def consultation_method_label
    I18n.t("activerecord.attributes.fortune_record.methods.#{consultation_method}")
  end
end
