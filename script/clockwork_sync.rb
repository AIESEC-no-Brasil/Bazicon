require 'clockwork'

# Require the full rails environment if needed
require './config/boot'
require './config/environment'

include Clockwork

# Define the jobs
handler do |job|
  if job.eql?('oGV')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "check_problematic_applications", "params" => { "programs" => "[1]", "for_filter" => "people" } })
  elsif job.eql?('oGE')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "check_problematic_applications", "params" => { "programs" => "[5]", "for_filter" => "people" } })
  elsif job.eql?('oGT')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "check_problematic_applications", "params" => { "programs" => "[2]", "for_filter" => "people" } })
  elsif job.eql?('iGV')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "check_problematic_applications", "params" => { "programs" => "[1]", "for_filter" => "opportunities" } })
  elsif job.eql?('iGE')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "check_problematic_applications", "params" => { "programs" => "[5]", "for_filter" => "opportunities" } })
  elsif job.eql?('iGT')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "check_problematic_applications", "params" => { "programs" => "[2]", "for_filter" => "opportunities" } })
  elsif job.eql?('opportunities')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "check_problematic_opportunities" })
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
#every(1.day, 'list all applications and update people', :at => '16:48')
