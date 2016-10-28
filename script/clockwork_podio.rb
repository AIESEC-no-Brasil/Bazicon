require 'clockwork'

# Require the full rails environment if needed
require './config/boot'
require './config/environment'

include Clockwork

# Define the jobs
handler do |job|
  if job.eql?('Get offline lead from Podio and send them to RD')
    Sync.new.rd_from_podio_offline_lead
  elsif job.eql?('Update Podio')
    Sync.new.update_podio
  elsif job.eql?('OP not working')
    Sync.new.almost_leads_to_podio
  end
  puts "Running Podio #{job} starting #{Time.now}"
end

# Define the schedule
every(3.hours, 'Get offline lead from Podio and send them to RD')
#every(30.minutes, 'Update Podio')
#every(1.day, 'OP not working', :at => '01:00')