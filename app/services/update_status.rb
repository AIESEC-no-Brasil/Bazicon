class UpdateStatus
  attr_reader :status, :params

  def initialize(params)
    @status = params[:status]
    @payment = Payment.find(params[:payment])
  end

  def self.call(params)
    new(params).call
  end

  def call
    @payment.status = @status
    @payment.save
  end
end
