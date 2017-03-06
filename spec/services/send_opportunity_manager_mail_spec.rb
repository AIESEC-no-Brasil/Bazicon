require 'rails_helper'

RSpec.describe SendOpportunityManagerMail do
  subject { SendOpportunityManagerMail.new("application", "status") }

  it { is_expected.to respond_to(:call) }
  it { is_expected.to respond_to(:application) }
  it { is_expected.to respond_to(:status) }
end
