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
    PagarMe::Transaction.find(payment.pagarme_id)
  end

  def capture(transaction)
    transaction.capture(amount: payment.value, metadata: {
      application_id: payment.application_id,
      opportunity_name: payment.opportunity_name.humanize,
      program: payment.program.humanize,
      lc: payment.local_committee,
      tag: payment.tag
      })
  end
end
