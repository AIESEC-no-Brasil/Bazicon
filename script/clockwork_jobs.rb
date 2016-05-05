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
  elsif job.eql?('Update all approved and realized Applications')
    ExpaRdSync.new.list_approved_realized_applications
  elsif job.eql?('Update all applications')
    ExpaRdSync.new.list_applications
  elsif job.eql?('Get all GCDP interested people')
    ExpaRdSync.new.list_igcdp_people
  end
end

# Define the schedule
every(8.minutes, 'list all open people')
every(10.minutes, 'Get offline lead from Podio and send them to RD')
every(30.minutes, 'Update Podio')
every(2.days, 'Update all People', :at => '21:00')
every(3.days, 'Update all approved and realized Applications', :at => '21:00')
every(1.week, 'Update all applications', :at => 'Saturday 21:00')
every(1.day, 'Get all GCDP interested people', :at => '21:00')