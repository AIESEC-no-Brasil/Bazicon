require 'rails_helper'

RSpec.describe SendToExpa do
  let(:invalid_params) do
    {
      "email"=>"test@example.com",
      "name"=>"John",
      "lastname"=>"Doe",
      "password"=>"12345",
      "lc"=>"1",
      "interested_program"=>"1"
    }
  end

  subject(:service) { SendToExpa.new(invalid_params) }

  it { is_expected.to respond_to(:call) }

  it { is_expected.to respond_to(:params) }

  it { is_expected.to respond_to(:status) }

  context 'failure' do
    it 'states as false when given method fails' do
      expect(SendToExpa.call(invalid_params)).to eq false
    end
  end
end
