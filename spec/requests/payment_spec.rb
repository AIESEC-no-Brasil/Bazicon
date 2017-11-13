require 'rails_helper'

RSpec.describe "Payment", type: :request do
  context "#new" do
    it "denies public access" do
      get new_payment_path

      expect(response).to redirect_to new_user_session_path
    end
  end
end
