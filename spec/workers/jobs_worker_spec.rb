require 'rails_helper'

RSpec.describe JobsWorker do

  before do
    stub_const 'TestJob', Class.new
    TestJob.class_eval { def self.call; new.call; end}
    TestJob.class_eval { def call; puts "Hooray! I've been called!"; end }
  end

  let(:body) { { "name" => "TestJob" } }

  let(:worker) { JobsWorker.new }

  subject { worker }

  it { is_expected.to respond_to(:perform) }

  context 'success' do
    it 'calls class reflected by body message' do
      expect(TestJob).to receive(:call)

      worker.perform(nil, body)
    end
  end

  context 'failure' do
    it 'raises exception when calling non-existent job' do
      body = { "name" => "NonExistentJob" }

      expect{ worker.perform(nil, body) }.to raise_exception(NameError, "Not a defined job")
    end
  end
end
