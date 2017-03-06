class ExpaOpportunityManager < ApplicationRecord
  belongs_to :expa_opportunity
  belongs_to :expa_manager

  validates :expa_opportunity_id, presence: true
  validates :expa_manager_id, presence: true
end
