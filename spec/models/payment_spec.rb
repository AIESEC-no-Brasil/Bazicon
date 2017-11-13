require 'rails_helper'

RSpec.describe Payment, type: :model do
  it { is_expected.to respond_to :customer_name }
  it { is_expected.to respond_to :local_committee }
  it { is_expected.to respond_to :application_id }
  it { is_expected.to respond_to :program }
  it { is_expected.to respond_to :opportunity_name }
  it { is_expected.to respond_to :value }

  it { is_expected.to validate_presence_of(:customer_name) }
  it { is_expected.to validate_presence_of(:local_committee) }
  it { is_expected.to validate_presence_of(:application_id) }
  it { is_expected.to validate_presence_of(:program) }
  it { is_expected.to validate_presence_of(:opportunity_name) }
  it { is_expected.to validate_presence_of(:value) }

end
