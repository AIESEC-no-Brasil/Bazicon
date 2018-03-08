require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let(:user) { create(:user) }
  let(:payment) { create(:payment) }
  let!(:pagarme_transaction) { create(:pagarme_transaction, status: :created, payment_id: payment.id) }
  let(:payments) { Payment.where(local_committee: user.local_committee) }

  before do
    user.save
    sign_in(user, scope: :user)
  end

  describe "#new" do
    before { get :new }

    it { is_expected.to expose(:user).as user }
    it { is_expected.to expose(:payment) }
    it { expect(controller.payment.local_committee).to eq user.local_committee }
  end

  describe "#create" do
    subject(:do_create) do
      post :create, params: { payment: create_attributes }
    end

    let(:create_attributes) { attributes_for :payment }

    context "on success" do
      it { is_expected.to redirect_to payment_path(Payment.last, created: true) }
      it { expect { do_create }.to change(Payment, :count).by(1) }
    end
  end

  describe "#index" do
    subject(:do_index) { get :index }

    before { create_list(:payment, 3) }

    it { expect(controller.payments).to match_array payments }
  end

  describe "#show" do
    before do
      payment.save
      get :show, params: { id: payment.slug }
    end

    it { is_expected.to expose(:payment).as payment }
  end

  describe "#destroy" do
    before { payment.save }
    subject(:do_delete) do
      delete :destroy, params: { id: payment.slug }
    end

    it { expect { do_delete }.to change(Payment, :count).by(-1) }
    it { is_expected.to redirect_to action: :index }
  end
end
