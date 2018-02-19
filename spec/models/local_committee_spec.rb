require 'rails_helper'

RSpec.describe LocalCommittee, type: :model do
  it { is_expected.to respond_to :name_key }
  it { is_expected.to respond_to :recipient_id }

  it { is_expected.to have_many :payments }

  it { is_expected.to validate_presence_of :name_key }
  it { is_expected.to validate_presence_of :recipient_id }

  describe "#contract_path" do
    let(:local_committee) { create(:local_committee, name_key: "curitiba") }
    subject { local_committee.contract_path }

    it { is_expected.to include("curitiba.pdf") }
  end
end
