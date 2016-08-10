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
  end
  puts "Running Podio #{job} starting #{Time.now}"
end

# Define the schedule
#every(8.minutes, 'list all open people')
every(10.minutes, 'Get offline lead from Podio and send them to RD')
every(30.minutes, 'Update Podio')