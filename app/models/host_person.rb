#THe business logic is uncomplete after list_leads, almost averything. 

class HostPerson < ActiveRecord::Base
	has_many :trainee_to_hosts
	has_many :trainee_people, through: :trainee_to_hosts



	def self.list_leads
		host = HostPerson.arel_table
		leads = HostPerson.where(host[:tmp_responsable_id].eq(nil).
															or(host[:tmp_who_realized_meeting_id].eq(nil)).
															or(host[:date_approach].eq(nil)).
															or(host[:date_alignment_meeting].gteq(Time.now)))
	end
#FIXME
	def self.list_free
		host = HostPerson.arel_table
		t2host = TraineeToHost.arel_table
		free = HostPerson.joins(:trainee_to_hosts).where(host[:tmp_responsable_id].not_eq(nil).
															and(host[:tmp_who_realized_meeting_id].not_eq(nil)).
															and(host[:date_approach].not_eq(nil)).
															and(host[:date_alignment_meeting].lt(Time.now)).
															and(host[:trainees_vacancy].gt(HostPerson.joins(:trainee_to_hosts).count()))) #Trainees vacancy must be greater than the number of trainees associated to the host
		end
#FIXME
	def self.list_allocated
		host = HostPerson.arel_table
		t2host = TraineeToHost.arel_table
		allocated = HostPerson.joins(:trainee_to_hosts).where(host[:tmp_responsable_id].not_eq(nil).
															and(host[:tmp_who_realized_meeting_id].not_eq(nil)).
															and(host[:date_approach].not_eq(nil)).
															and(host[:date_alignment_meeting].lt(Time.now)).
															and(t2host[:entry_date].lt(Time.now)))
	end
#FIXME
	def self.list_realized
		host = HostPerson.arel_table
		t2host = TraineeToHost.arel_table
		realized = HostPerson.joins(:trainee_to_hosts).where(host[:tmp_responsable_id].not_eq(nil).
															and(host[:tmp_who_realized_meeting_id].not_eq(nil)).
															and(host[:date_approach].not_eq(nil)).
															and(host[:date_alignment_meeting].lt(Time.now)).
															and(t2host[:entry_date].gteq(Time.now)).
															and(t2host[:leaving_date].lt(Time.now)))
	end

	def self.list_favourites
		favourites = HostPerson.where({is_favourite: true})
	end

	def self.list_problematics
		problematics = HostPerson.where({is_problematic: true})
	end

	def self.list_non_grata
		non_grati = HostPerson.where({is_non_grata: true})
	end
end




