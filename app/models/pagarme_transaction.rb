class PagarmeTransaction < ApplicationRecord
  validates :pagarme_id, presence: true
  validates :payment_id, presence: true

  enum status: {
    processing: 0,
    authorized: 1,
    paid: 2,
    refunded: 3,
    waiting_payment: 4,
    pending_refund: 5,
    refused: 6,
    chargedback: 7,
    created: 8
  }
end
