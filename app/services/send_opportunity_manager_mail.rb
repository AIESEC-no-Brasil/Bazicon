class SendOpportunityManagerMail
  def self.call(application)
    new(application).call
  end

  attr_reader :application, :status

  def initialize(application, status)
    @application = application
    @status = status
  end

  def call
    opportunity = @application.xp_opportunity
    managers = opportunity.expa_managers

    managers.each do |manager|

    end

  end
end
