class ExpaManager < ApplicationRecord
  has_many :expa_opportunity_managers

  validates :xp_id, presence: true
  validates :name, presence: true
  validates :email, presence: true
  validates :profile_photo_url, presence: true
end
