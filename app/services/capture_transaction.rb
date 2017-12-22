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
    @status = false unless capture(transaction(payment))
  end

  private

  def load_payment(payment_id)
    Payment.find_by(id: @payment_id)
  end

  def load_transaction(payment)
    PagarMe::Transaction.find(payment.pagarme_id)
  end

  def capture(transaction)
    transaction = load_transaction(load_payment)
    transaction.capture(amount: payment.value, metadata: {
      application_id: payment.application_id,
      opportunity_name: payment.opportunity_name.humanize,
      program: payment.program.humanize,
      lc: payment.local_committee,
      tag: payment.tag
      })
  end
end
