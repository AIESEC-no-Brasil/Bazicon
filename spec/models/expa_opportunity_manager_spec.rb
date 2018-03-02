require 'rails_helper'

RSpec.describe ExpaOpportunityManager, type: :model do
  subject { FactoryBot.build(:expa_opportunity_manager) }

  it { is_expected.to belong_to(:expa_opportunity) }
  it { is_expected.to belong_to(:expa_manager) }

  it { is_expected.to respond_to(:expa_opportunity_id) }
  it { is_expected.to respond_to(:expa_manager_id) }

  it { is_expected.to validate_presence_of(:expa_opportunity_id) }
  it { is_expected.to validate_presence_of(:expa_manager_id) }
end
