class SendDataToSqs
  def self.call(params)
    new(params).call
  end

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    perform_on_worker
  end

  private

  def perform_on_worker
    AiesecGlobalWorker.perform_async(@params)
  end
end
