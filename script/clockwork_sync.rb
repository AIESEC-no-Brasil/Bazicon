require 'clockwork'

# Require the full rails environment if needed
require './config/boot'
require './config/environment'

include Clockwork

# Define the jobs
handler do |job|
  if job.eql?('oGV')
    Sync.new.check_problematic_applications({ "programs" => "[1]", "for_filter" => "people" })
  elsif job.eql?('oGE')
    Sync.new.check_problematic_applications({ "programs" => "[5]", "for_filter" => "people" })
  elsif job.eql?('oGT')
    Sync.new.check_problematic_applications({ "programs" => "[2]", "for_filter" => "people" })
  elsif job.eql?('iGV')
    Sync.new.check_problematic_applications({ "programs" => "[1]", "for_filter" => "opportunities" })
  elsif job.eql?('iGE')
    Sync.new.check_problematic_applications({ "programs" => "[5]", "for_filter" => "opportunities" })
  elsif job.eql?('iGT')
    Sync.new.check_problematic_applications({ "programs" => "[2]", "for_filter" => "opportunities" })
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
