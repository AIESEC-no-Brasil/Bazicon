require 'rails_helper'

RSpec.describe JobsWorker do

  before do
    stub_const 'TestJob', Class.new
    TestJob.class_eval { def existent_method; end }
  end

  let(:body) { { "klass" => "TestJob", "method" => "existent_method" } }

  let(:worker) { JobsWorker.new }

  subject { worker }

  it { is_expected.to respond_to(:perform) }

  context 'success' do
    context 'without params' do
      it 'calls desired method from specified class' do
        expect_any_instance_of(TestJob).to receive(:existent_method)

        worker.perform(nil, body)
      end
    end

    context 'with params' do
      it 'calls desired method from specified class with its params' do
        body = { "klass" => "TestJob", "method" => "existent_method", "params" => { "a" => 123, "b" => 456 } }

        TestJob.class_eval { def existent_method(a); end }

        expect_any_instance_of(TestJob).to receive(:existent_method).with(body["params"])

        worker.perform(nil, body)
      end
    end
  end

  context 'failure' do
    it 'raises exception when calling non-existent job' do
      body = { "method" => "non_existent_method" }

      expect{ worker.perform(nil, body) }.to raise_exception(NameError, "Not a defined job")
    end
  end
end
