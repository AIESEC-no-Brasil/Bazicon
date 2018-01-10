require 'rails_helper'

RSpec.describe CaptureTransaction do
  let(:service) { CaptureTransaction.new(1) }

  subject { service }

  it { is_expected.to respond_to(:payment_id) }

  it { is_expected.to respond_to(:call) }

  it { is_expected.to respond_to(:status) }

  context 'credit card transactions' do
    it 'successfully captures an authorized transaction' do
      # create credit card transaction

      # capture credit card transaction

      # check credit card transaction status
    end
  end

  context 'boleto transactions' do
    it 'successfully captures an authorized transaction' do
      # create boleto transaction

      # capture boleto transaction

      # check boleto transaction status
    end
  end
end
