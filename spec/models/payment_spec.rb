require 'rails_helper'

RSpec.describe Payment, type: :model do
  it { is_expected.to respond_to :customer_name }
  it { is_expected.to respond_to :customer_email }
  it { is_expected.to respond_to :local_committee }
  it { is_expected.to respond_to :application_id }
  it { is_expected.to respond_to :program }
  it { is_expected.to respond_to :opportunity_name }
  it { is_expected.to respond_to :value }
  it { is_expected.to respond_to :slug }

  it { is_expected.to validate_presence_of(:customer_name) }
  it { is_expected.to validate_presence_of(:customer_email) }
  it { is_expected.to validate_presence_of(:local_committee) }
  it { is_expected.to validate_presence_of(:application_id) }
  it { is_expected.to validate_presence_of(:program) }
  it { is_expected.to validate_presence_of(:opportunity_name) }
  it { is_expected.to validate_presence_of(:value) }
  it { is_expected.to validate_uniqueness_of(:slug) }

  it { is_expected.to allow_value('test@example.com').for(:customer_email) }

  it { is_expected.not_to allow_values('testexample').for(:customer_email) }

  it { is_expected.to define_enum_for(:program)
        .with [ :gv, :ge, :gt ] }
  it { is_expected.to define_enum_for(:status)
        .with [ :processing, :authorized, :paid, :refunded,
                :waiting_payment, :pending_refund,
                :refused, :chargedback, :created ] }
  it { is_expected.to define_enum_for(:local_committee)
        .with [ :curitiba, :brasilia, :limeira, :porto_alegre, :belo_horizonte ] }

  it { is_expected.to define_enum_for(:payment_method)
        .with [:credit_card, :boleto] }

  describe 'program_fee' do
    context 'returns correct fee for defined program' do
      let(:payment) { FactoryGirl.create(:payment, program: "gv") }

      it 'when gv' do
        expect(payment.program_fee).to eq(54738)
      end

      it 'when ge' do
        payment.update(program: "ge")

        expect(payment.program_fee).to eq(65101)
        payment.reload
      end

      it 'when gt' do
        payment.update(program: "gt")

        expect(payment.program_fee).to eq(109245)
        payment.reload
      end
    end
  end
end
