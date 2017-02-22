require 'clockwork'

# Require the full rails environment if needed
require './config/boot'
require './config/environment'

include Clockwork

# Define the jobs
handler do |job|
  if job.eql?('oGV')
    Sync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,02,22),[1],"people",'date_matched')
    Sync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,02,22),[1],"people",'date_an_signed')
    Sync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,02,22),[1],"people",'date_approved')
    Sync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,02,22),[1],"people",'date_realized')
    Sync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,02,22),[1],"people",'experience_start_date')
    Sync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,02,22),[1],"people",'experience_end_date')
  elsif job.eql?('oGE')
    Sync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,02,22),[5],"people")
  elsif job.eql?('oGT')
    Sync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,02,22),[2],"people")
  elsif job.eql?('iGV')
    Sync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,02,22),[1],"opportunities")
  elsif job.eql?('iGE')
    Sync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,02,22),[5],"opportunities")
  elsif job.eql?('iGT')
    Sync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,02,22),[2],"opportunities")
  elsif job.eql?('opportunities')
    Sync.new.check_problematic_opportunities
  end
  puts "Running EXPA #{job} starting #{Time.now}"
end

# Define the schedule
every(3.day, 'oGE')
every(3.day, 'oGT')
every(3.day, 'iGV')
every(3.day, 'iGE')
every(3.day, 'iGT')
every(3.day, 'oGV')
every(3.day, 'opportunities')
