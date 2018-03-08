class CaptureTransaction
  require 'pagarme'

  def self.call(payment_id)
    new(payment_id).call
  end

  attr_reader :payment_id, :status

  def initialize(payment_id)
    @payment_id = payment_id
    @status = true

    PagarMe.api_key = ENV["PAGARME_API_KEY"]
  end

  def call
    @status = false unless capture_transaction
  end

  private

  def capture_transaction
    capture(transaction(payment))
  end

  def payment
    Payment.find_by(id: @payment_id)
  end

  def transaction(payment)
    PagarMe::Transaction.find(payment.pagarme_transactions.last.pagarme_id)
  end

  def capture(transaction)
    transaction.capture(amount: payment.value, metadata: {
      application_id: payment.application_id,
      opportunity_name: payment.opportunity_name.humanize,
      program: payment.program.humanize,
      lc: payment.local_committee,
      tag: payment.tag
      },
      split_rules: [
        {
          recipient_id: ENV["AIESEC_BANK_ACCOUNT"],
          amount: payment.program_fee,
          liable: true,
          charge_processing_fee: true
        },{
          recipient_id: payment.local_committee.recipient_id,
          amount: (payment.value - payment.program_fee),
          liable: true,
          charge_processing_fee: true
        }
      ])
  end
end
