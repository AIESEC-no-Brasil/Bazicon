require 'rails_helper'

RSpec.describe ExpaManager, type: :model do
  subject { FactoryGirl.build(:expa_manager) }

  it { is_expected.to have_many(:expa_opportunity_managers) }

  it { is_expected.to respond_to :xp_id }
  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :email }
  it { is_expected.to respond_to :profile_photo_url }

  it { is_expected.to validate_presence_of(:xp_id) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:profile_photo_url) }
end
