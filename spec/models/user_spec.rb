require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to respond_to(:local_committee) }
  it { is_expected.to validate_presence_of(:local_committee) }

  it { is_expected.to belong_to :local_committee }
end
