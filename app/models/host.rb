class Host < ActiveRecord::Base
	enum how_got_to_know_aiesec: [:facebook, :friends_family, :google, :posters, :tv, :twitter, :academic_center, :junior_company, :flyer, :disclouse_in_classroom, :global_village, :stand, :instagram, :indication_campaign, :youth_speak, :other]
	enum house_type: [:family_house, :hostel, :dorm, :flat]

	belongs_to :nearest_lc, class_name: 'ExpaOffice'
	belongs_to :tmp_responsable, class_name: 'ExpaPerson'
	belongs_to :tmp_who_realized_meeting, class_name: 'ExpaPerson'

	has_many :hosts_people, class_name: 'HostPerson'
	has_many :trainees, through: :hosts_people	

	def self.list_problematics
		Host.where(is_problematic: true)
	end

	def self.list_free
		Host.where.not("tmp_responsable_id=? AND
					tmp_who_realized_meeting_id=? AND date_approach=? AND date_alignment_meeting>?", nil, nil, nil, Time.now)
	end
end

class HostPerson < ActiveRecord::Base
	belongs_to :host, class_name: 'Host'
	belongs_to :person, class_name: 'ExpaPerson'
end

class HostProblem < ActiveRecord::Base
	belongs_to :host_problems, class_name: 'Host'
end

