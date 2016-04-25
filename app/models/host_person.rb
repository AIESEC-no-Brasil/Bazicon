class HostPerson < ActiveRecord::Base
	
	def self.list_leads
		leads = HostPerson.where("tmp_responsable_id=? 
								OR tmp_who_realized_meeting_id=?
								OR date_approach=?
								OR date_alignment_meeting=?", nil, nil, nil, nil)
	end

	def self.list_free
		free = HostPerson.where("tmp_responsable_id != ? 
								and tmp_who_realized_meeting_id !=?
								and date_approach != ?
								and date_alignment_meeting < ?", nil, nil, nil, Time.now)
	end
end
