class SendOpportunityManagerMail
  STATUSES = [:open, :accepted, :approved, :realized, :matched, :completed]

  def self.call(application, status)
    new(application, status).call
  end

  attr_reader :application, :status

  def initialize(application, status)
    @application = application
    @status = status
  end

  def call
    opportunity = @application.xp_opportunity
    managers = opportunity.expa_managers
    person = @application.xp_person
    subject = {}

    if @status.to_sym.in?(STATUSES)
      send_emails(opportunity, managers, person)
    end
  end

  private

  def send_emails(opportunity, managers, person)
    subject = []

    managers.each do |manager|
      subject = I18n.t("emails.opportunity_manager.#{@status}.title", manager_name: manager.name)

      ac = ActionController::Base.new()
      text = ac.render_to_string(partial: "mailers/opportunity_managers/#{@status.to_s}",
                                 locals: {
                                  manager_name: manager.name,
                                  opportunity_title: opportunity.xp_title,
                                  opportunity_id: opportunity.xp_id,
                                  person_name: person.xp_full_name,
                                  person_email: person.xp_email,
                                  managers: person.expa_managers
                                }
                               )

      Mailgunner.call('no-reply@aiesec.org.br',
                      manager.email,
                      subject,
                      text
                      )
    end
  end
end
