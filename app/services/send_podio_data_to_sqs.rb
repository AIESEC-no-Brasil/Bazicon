class SendPodioDataToSqs
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

    @status
  end

  private

  def perform_on_worker
    PodioWorker.perform_async(@params)
  end
end
