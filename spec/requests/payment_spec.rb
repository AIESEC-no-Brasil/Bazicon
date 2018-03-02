require 'rails_helper'

RSpec.describe "Payment", type: :request do
  context "#new" do
    it "denies public access" do
      get new_payment_path

      expect(response).to redirect_to new_user_session_path
    end

    it "allows access to logged in user" do
      sign_in FactoryBot.create(:user)
      get new_payment_path

      expect(response).to have_http_status(200)
    end
  end

  context "#create" do
    it "denies public access" do
      payment_attributes = FactoryBot.attributes_for(:payment)

      expect {
        post "/payments", params: { payment: payment_attributes }
      }.not_to change(Payment, :count)

      expect(response).to redirect_to new_user_session_path
    end

    context "logged in user" do
      let(:user) { create(:user) }

      before { sign_in(user) }
      
      it "allows access to logged in user" do
        payment_attributes = FactoryBot.attributes_for(:payment)

        expect {
          post "/payments", params: { payment: payment_attributes }
        }.to change(Payment, :count)
      end
    end
  end
end
