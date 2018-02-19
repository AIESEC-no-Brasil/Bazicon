class LocalCommittee < ApplicationRecord
  validates :name_key, presence: true
  validates :receiver_id, presence: true

  has_many :payments

  def contract_path
    "/contracts/#{ self.name_key }.pdf"
  end
end
