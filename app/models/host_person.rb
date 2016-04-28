class HostPerson < ActiveRecord::Base
	
	def self.list_leads
		host = HostPerson.arel_table
		leads = HostPerson.where(host[:tmp_responsable_id].eq(nil).
															or(host[:tmp_who_realized_meeting_id].eq(nil)).
															or(host[:date_approach].eq(nil)).
															or(host[:date_alignment_meeting].gteq(Time.now)))
	end

	def self.list_free
		free = HostPerson.where("tmp_responsable_id IS NOT NULL").
														where("tmp_who_realized_meeting_id IS NOT NULL").
														where("date_approach IS NOT NULL").
														where("date_alignment_meeting<?",Time.now)
	end

	def self.list_allocated
		allocated = HostPerson.where()
	end

	def self.list_realized
	end
end
