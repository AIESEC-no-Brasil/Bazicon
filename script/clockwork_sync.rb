require 'clockwork'

# Require the full rails environment if needed
require './config/boot'
require './config/environment'

include Clockwork

# Define the jobs
handler do |job|
  if job.eql?('list new open people')
    Sync.new.get_new_people_from_expa
  elsif job.eql?('oGV')
    Sync.new.check_problematic_applications(Date.new(2016,1,1),Date.new(2016,12,31),[1],'people')
  elsif job.eql?('oGE')
    Sync.new.check_problematic_applications(Date.new(2016,1,1),Date.new(2016,12,31),[5],'people')
  elsif job.eql?('oGT')
    Sync.new.check_problematic_applications(Date.new(2016,1,1),Date.new(2016,12,31),[2],'people')
  elsif job.eql?('iGV')
    Sync.new.check_problematic_applications(Date.new(2016,1,1),Date.new(2016,12,31),[1],'opportunities')
  elsif job.eql?('iGE')
    Sync.new.check_problematic_applications(Date.new(2016,1,1),Date.new(2016,12,31),[5],'opportunities')
  elsif job.eql?('iGT')
    Sync.new.check_problematic_applications(Date.new(2016,1,1),Date.new(2016,12,31),[2],'opportunities')
  elsif job.eql?('opportunities')
    Sync.new.check_problematic_opportunities(Date.new(2016,1,1),Date.new(2016,12,31))
  end
  puts "Running EXPA #{job} starting #{Time.now}"
end

# Define the schedule
#every(1.day, 'oGE')
#every(1.day, 'oGT')
#every(1.day, 'iGV')
#every(1.day, 'iGE')
#every(1.day, 'iGT')
#every(1.day, 'oGV')
every(1.day, 'opportunities')
#every(1.day, 'list all applications and update people', :at => '16:48')