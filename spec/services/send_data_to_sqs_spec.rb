require 'rails_helper'

RSpec.describe SendDataToSqs do
  let(:params) do
    {
      email: 'test@example.com',
      name: 'John',
      lastname: 'Doe',
      password: '12345678',
      lc: '1',
      interested_program: '1'
    }
  end

  let(:service) { SendDataToSqs.new(params) }

  subject { service }

  it { is_expected.to respond_to(:call) }

  it { is_expected.to respond_to(:params) }

  it 'performs asynchronously on worker with its params' do
    expect(AiesecGlobalWorker).to receive(:perform_async).with(params)

    service.call
  end
end
