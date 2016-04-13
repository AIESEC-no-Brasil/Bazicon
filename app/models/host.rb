class Host < ActiveRecord::Base
	enum how_got_to_know_aiesec: [:facebook, :friends_family, :google, :posters, :tv, :twitter, :academic_center, :junior_company, :flyer, :disclouse_in_classroom, :global_village, :stand, :instagram, :indication_campaign, :youth_speak, :other]
	enum house_type: [:family_house, :hostel, :dorm, :flat]

	belongs_to :nearest_lc, class_name: 'ExpaOffice'
	belongs_to :tmp_responsable, class_name: 'ExpaPerson'
	belongs_to :tmp_who_realized_meeting, class_name: 'ExpaPerson'

	has_many :hosts_people, class_name: 'HostPerson'
	has_many :trainees, through: :hosts_people	
end

class HostPerson < ActiveRecord::Base
	belongs_to :host, class_name: 'Host'
	belongs_to :person, class_name: 'ExpaPerson'
end

class HostProblem < ActiveRecord::Base
	belongs_to :host_problems, class_name: 'Host'
end

module Hosts
	class << self
		def list_problematics
			Host.where(is_problematic: true)
		end
		
		def list_leads
			Host.where({tmp_responsable_id: nil,
						date_approach: nil,
						date_alignment_meeting: nil,
						tmp_who_realized_meeting_id: nil,
						is_favourite: false,
						is_problematic: false})
		end	
		
		'''
		def list_free
			Host.where({Host.tmp_responsable_id.not_eq(nil): true, 
						Host.date_approach.not_eq(nil): true, 
						Host.date_alignment_meeting.not_eq(nil): true,
						Host.tmp_who_realized_meeting_id.not_eq(nil): true,
						Host.is_favourite.not_eq(nil): true,
						Host.is_problematic.not_eq(nil): true,
						Host.is_non_grata.not_eq(nil): true})
		end
		'''
	end
end