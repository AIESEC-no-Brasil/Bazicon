require 'clockwork'

# Require the full rails environment if needed
require './config/boot'
require './config/environment'

include Clockwork

# Define the jobs
handler do |job|
  if job.eql?('list all open people')
    ExpaRdSync.new.list_open
  elsif job.eql?('Update all People')
    ExpaRdSync.new.list_people
  elsif job.eql?('Update all approved and realized Applications')
    ExpaRdSync.new.list_approved_realized_applications
  elsif job.eql?('Update all applications')
    ExpaRdSync.new.list_applications
  elsif job.eql?('Get all GCDP interested people')
    ExpaRdSync.new.list_igcdp_people(50)
  elsif job.eql?('Get all GIP interested people')
    ExpaRdSync.new.list_igip_people(50)
  end
end

# Define the schedule
every(8.minutes, 'list all open people')
every(30.minutes, 'Get all GCDP interested people')
every(30.minutes, 'Get all GIP interested people')
every(2.days, 'Update all People', :at => '21:00')
every(3.days, 'Update all approved and realized Applications', :at => '21:00')
every(1.week, 'Update all applications', :at => 'Saturday 21:00')
