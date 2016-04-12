module HostDAO
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
                  is_problematic: false,
                  is_non_grata: false})
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