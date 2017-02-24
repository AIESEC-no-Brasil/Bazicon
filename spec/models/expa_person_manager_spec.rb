require 'rails_helper'

RSpec.describe ExpaPersonManager, type: :model do
  subject { FactoryGirl.build(:expa_person_manager) }

  it { is_expected.to belong_to(:expa_person) }
  it { is_expected.to belong_to(:expa_manager) }
end
