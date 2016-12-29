class SendDataToSqs
  def self.call(params)
    new(params).call
  end

  attr_reader :params, :status

  def initialize(params)
    @params = params
    @status = true
  end

  def call
    @status = false unless perform_on_worker
  end

  private

  def perform_on_worker
    AiesecGlobalWorker.perform_async(@params)
  end
end