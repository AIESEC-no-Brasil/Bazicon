class Payment < ApplicationRecord
  validates :customer_name, presence: true
  validates :local_committee, presence: true
  validates :application_id, presence: true
  validates :program, presence: true
  validates :opportunity_name, presence: true
  validates :value, presence: true
end
