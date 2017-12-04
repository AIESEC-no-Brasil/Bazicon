class Payment < ApplicationRecord
  validates :customer_name, presence: true
  validates :local_committee, presence: true
  validates :application_id, presence: true
  validates :program, presence: true
  validates :opportunity_name, presence: true
  validates :value, presence: true

  enum program: { gv: 0, ge: 1, gt: 2 }
  enum local_committee: {
    curitiba: 0,
    brasilia: 1,
    limeira: 2,
    porto_alegre: 3,
    uberlandia: 4
  }
  enum status: {
    pending: 0,
    paid: 1
  }

end
