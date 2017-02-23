class ExpaManager < ApplicationRecord
  has_many :expa_opportunity_managers
  has_many :expa_opportunities, through: :expa_opportunity_managers

  validates :xp_id, presence: true
  validates :name, presence: true
  validates :email, presence: true
  validates :profile_photo_url, presence: true

  def self.id_by_xp_id(xp_id)
    ExpaManager.find_by(xp_id: xp_id).id if ExpaManager.find_by(xp_id: xp_id)
  end
end
