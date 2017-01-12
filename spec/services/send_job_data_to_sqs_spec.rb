require 'rails_helper'

RSpec.describe SendJobDataToSqs do
  let(:params) do
    {
      'name' => 'test_method'
    }
  end

  let(:service) { SendJobDataToSqs.new(params) }

  subject { service }

  it { is_expected.to respond_to(:call) }

  it { is_expected.to respond_to(:params) }

  it { is_expected.to respond_to(:status) }

  context 'success' do
    it 'performs asynchronously on worker with its params' do
      expect(JobsWorker).to receive(:perform_async).with(params)

      service.call
    end
  end

  context 'failure' do
    it 'states as false when given worker fails' do
      allow_any_instance_of(SendJobDataToSqs).to receive(:call).and_return(false)

      expect(service.call).to eq false
    end
  end
end
