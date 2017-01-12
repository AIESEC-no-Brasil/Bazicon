class SendJobDataToSqs
  def self.call(params)
    new(params).call
  end

  attr_reader :params, :status

  def initialize(params)
    @params = { 'name' => params }
    @status = true
  end

  def call
    @status = false unless perform_on_worker

    @status
  end

  private

  def perform_on_worker
    JobsWorker.perform_async(@params)
  end
end
