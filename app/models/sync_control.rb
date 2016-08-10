class SyncControl < ActiveRecord::Base

	def self.get_last(type)
		SyncControl.order(start_sync: :desc).limit(1).first.start_sync
	end
end
