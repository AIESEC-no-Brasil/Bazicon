require 'clockwork'

# Require the full rails environment if needed
require './config/boot'
require './config/environment'

include Clockwork

# Define the jobs
handler do |job|
  if job.eql?('list all open people')
    ExpaRdSync.new.list_open
  elsif job.eql?('Get offline lead from Podio and send them to RD')
    ExpaRdSync.new.rd_from_podio_offline_lead
  elsif job.eql?('Update Podio')
    ExpaRdSync.new.update_podio
  elsif job.eql?('Update all People')
    ExpaRdSync.new.list_people
  elsif job.eql?('Update all Applications')
    ExpaRdSync.new.list_approved_realized_applications
  end
end

# Define the schedule
every(10.minutes, 'list all open people')
every(10.minutes, 'Get offline lead from Podio and send them to RD')
every(30.minutes, 'Update Podio')
every(2.days, 'Update all People', :at => '01:00')
every(3.days, 'Update all Applications', :at => '01:00')