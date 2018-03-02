require 'rails_helper'

RSpec.describe PagarmeTransaction, type: :model do
  it { is_expected.to respond_to(:pagarme_id) }
  it { is_expected.to respond_to(:payment_id) }
  it { is_expected.to respond_to(:status) }

  it { is_expected.to validate_presence_of(:payment_id) }

  it { is_expected.to define_enum_for(:status)
        .with [ :processing, :authorized, :paid, :refunded,
                :waiting_payment, :pending_refund,
                :refused, :chargedback, :created ] }
end
