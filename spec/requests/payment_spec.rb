require 'rails_helper'

RSpec.describe "Payment", type: :request do
  context "#new" do
    it "denies public access" do
      get new_payment_path

      expect(response).to redirect_to new_user_session_path
    end

    it "allows access to logged in user" do
      sign_in FactoryGirl.create(:user)
      get new_payment_path

      expect(response).to have_http_status(200)
    end
  end

  context "#create" do
    it "denies public access" do
      payment_attributes = FactoryGirl.attributes_for(:payment)

      expect {
        post "/payments", { payment: payment_attributes }
      }.not_to change(Payment, :count)

      expect(response).to redirect_to new_user_session_path
    end

    it "allows access to logged in user" do
      payment_attributes = FactoryGirl.attributes_for(:payment)

      expect {
        post "/payments", { payment: payment_attributes }
      }.to change(Payment, :count)

      expect(response).to have_http_status(200)
    end
  end
end
