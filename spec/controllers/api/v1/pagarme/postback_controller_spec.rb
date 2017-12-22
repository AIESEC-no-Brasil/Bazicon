require 'rails_helper'

RSpec.describe Api::V1::Pagarme::PostbackController, type: :controller do
  let(:payment) { FactoryGirl.create(:payment) }

  describe '#update_status' do
    before(:each) do
      Api::V1::Pagarme::PostbackController.any_instance.stub(:valid_postback?).and_return(true)
    end

    it 'updates payment status' do
      post :update_status, params: {
        payment_id: payment.id,
        event: "transaction_status_changed",
        current_status: "paid"
      }

      payment.reload

      expect(payment.status).to eq("paid")
    end

    # context 'authorized status' do
    #   it 'calls capture transaction' do
    #     # CaptureTransaction.any_instance.stub(:capture_transaction).and_return(true)
    #     # CaptureTransaction.stub(:call) { true }
    #     allow(CaptureTransaction).to receive(:call).and_return(true)
    #     post :update_status, params: {
    #       payment_id: payment.id,
    #       event: "transaction_status_changed",
    #       current_status: "authorized"
    #     }

    #     expect(CaptureTransaction).to receive(:call).with(payment.id)
    #   end
    # end
  end
end
