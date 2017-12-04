require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let(:user) { create(:user) }
  let(:payment) { controller.payment }

  before do
    user.save
    sign_in(user, scope: :user)
  end

  describe "#new" do
    before { get :new }

    it { is_expected.to expose(:user).as user }
    it { is_expected.to expose(:payment) }
    it { expect(payment.local_committee).to eq user.local_committee }
  end

  describe "#create" do
    subject(:do_create) do
      post :create, params: { payment: create_attributes }
    end

    let(:create_attributes) { attributes_for :payment }

    context "on success" do
      it { is_expected.to redirect_to payment_path(payment) }
      it { expect { do_create }.to change(Payment, :count).by(1) }
    end
  end

  describe "#index" do
    subject(:do_index) { get :index }
    let(:payments) { Payment.where(local_committee: user.local_committee) }

    #it { is_expected.to expose(:payments).as_collection payments }
  end

  describe "#show" do
    before do
      payment.save
      get :show, id: payment
    end

    it { is_expected.to expose(:payment).as payment }
  end
end
