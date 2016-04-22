class HostPerson < ActiveRecord::Base
	def self.list_free
		free = HostPerson.where.not("tmp_responsable_id=? 
									AND date_approach=?
									AND date_alignment_meeting=?", nil, nil, nil)
	end
end
