require 'rails_helper'

RSpec.describe ExpaPerson, type: :model do
  subject { FactoryGirl.build(:expa_person) }

  it { is_expected.to have_many(:expa_person_managers) }

  it { is_expected.to respond_to :xp_id }
end
