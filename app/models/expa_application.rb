class ExpaApplication < ActiveRecord::Base
  enum xp_current_status: [:current_open, :current_matched, :current_accepted, :current_approved, :current_realized, :current_completed, :current_withdrawn, :current_rejected, :current_declined, :current_approved_ep_manager, :current_approved_tn_manager, :current_acceptance_broken] #TODO: Use prefix when they launch outside edge
  enum xp_status: [:open, :matched, :accepted, :approved, :realized, :completed, :withdrawn, :rejected, :declined, :approved_ep_manager, :approved_tn_manager, :acceptance_broken] #TODO: Use prefix when they launch outside edge

  belongs_to :xp_person, class_name: 'ExpaPerson'
  belongs_to :xp_opportunity, class_name: 'ExpaOpportunity'

  validates :xp_id,
            uniqueness: true,
            presence: false

  def update_from_expa(data)
    unless data.opportunity.nil?
      opportunity = ExpaOpportunity.find_by_xp_id(data.opportunity.id)
      opportunity = ExpaOpportunity.new if opportunity.nil?
      opportunity.update_from_expa(data.opportunity)
      opportunity.save
    end
    unless data.person.nil?
      person = ExpaPerson.find_by_xp_id(data.person.id)
      person = ExpaPerson.new if person.nil?
      person.update_from_expa(data.person)
      person.save
    end

    self.xp_id = data.id unless data.id.nil?
    self.xp_url = data.url unless data.url.nil?
    self.xp_status = data.status.to_s.downcase.gsub(' ','_') unless data.status.nil?
    self.xp_current_status = 'current_' + data.current_status.to_s.downcase.gsub(' ','_') unless data.current_status.nil? #TODO: Use prefix when they launch outside edge
    self.xp_an_signed_at = data.an_signed_at unless data.an_signed_at.nil?
    self.xp_person = person unless person.nil?
    self.xp_opportunity = opportunity unless opportunity.nil?
    self.xp_permissions = data.permissions.to_s unless data.permissions.nil?
    self.xp_created_at = data.created_at unless data.created_at.nil?
    self.xp_updated_at = data.updated_at unless data.updated_at.nil?
    self.xp_interviewed = data.interviewed unless data.interviewed.nil?
    self.xp_paid = data.paid unless data.paid.nil?
    self.xp_paid_at = data.paid_at unless data.paid_at.nil?
    #self.xp_paid_by = data.paid_by unless data.paid_by.nil?
    self.xp_experience_start_date = data.experience_start_date unless data.experience_start_date.nil?
    self.xp_experience_end_date = data.experience_end_date unless data.experience_end_date.nil?
    self.xp_matched_or_rejected_at = data.matched_or_rejected_at unless data.matched_or_rejected_at.nil?
    self.xp_meta = (data.meta.nil? || data.meta.to_s.length <= 2) ? {} : data.meta
    self.xp_date_matched = data.date_matched unless data.date_matched.nil?
    self.xp_date_approved = data.date_approved unless data.date_approved.nil?
    self.xp_date_realized = data.date_realized unless data.date_realized.nil?
    self.xp_date_completed = data.date_completed unless data.date_completed.nil?
    self.xp_date_ldm_completed = data.date_ldm_completed unless data.date_ldm_completed.nil?
    #self.xp_matchability = data.matchability unless data.matchability.nil?
    #self.xp_favourite = data.favourite unless data.favourite.nil?
    #self.xp_branch = data.branch unless data.branch.nil?
    #self.xp_standards = data.standards unless data.standards.nil?
  end
end
