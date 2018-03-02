class PagarmeTransaction < ApplicationRecord
  validates :payment_id, presence: true

  belongs_to :payment

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
