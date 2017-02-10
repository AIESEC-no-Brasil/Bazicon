require 'rails_helper'

RSpec.describe ExpaOpportunityManager, type: :model do
  subject { FactoryGirl.build(:expa_opportunity_manager) }

  it { is_expected.to respond_to :xp_id }
  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :email }
  it { is_expected.to respond_to :profile_photo_url }
end
