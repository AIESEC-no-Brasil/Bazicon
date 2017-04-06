require 'clockwork'

# Require the full rails environment if needed
require './config/boot'
require './config/environment'

include Clockwork

# Define the jobs
handler do |job|
  if job.eql?('oGV')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"people",'created_at')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"people",'date_matched')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"people",'date_an_signed')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"people",'date_approved')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"people",'date_realized')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"people",'experience_start_date')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"people",'experience_end_date')
  elsif job.eql?('oGE')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"people",'created_at')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"people",'date_matched')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"people",'date_an_signed')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"people",'date_approved')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"people",'date_realized')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"people",'experience_start_date')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"people",'experience_end_date')
  elsif job.eql?('oGT')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"people",'created_at')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"people",'date_matched')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"people",'date_an_signed')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"people",'date_approved')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"people",'date_realized')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"people",'experience_start_date')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"people",'experience_end_date')
  elsif job.eql?('iGV')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"opportunities",'created_at')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"opportunities",'date_matched')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"opportunities",'date_an_signed')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"opportunities",'date_approved')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"opportunities",'date_realized')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"opportunities",'experience_start_date')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"opportunities",'experience_end_date')
  elsif job.eql?('iGE')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"opportunities",'created_at')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"opportunities",'date_matched')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"opportunities",'date_an_signed')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"opportunities",'date_approved')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"opportunities",'date_realized')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"opportunities",'experience_start_date')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"opportunities",'experience_end_date')
  elsif job.eql?('iGT')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"opportunities",'created_at')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"opportunities",'date_matched')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"opportunities",'date_an_signed')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"opportunities",'date_approved')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"opportunities",'date_realized')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"opportunities",'experience_start_date')
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"opportunities",'experience_end_date')
  elsif job.eql?('opportunities')
    ManualSync.new.check_problematic_opportunities(Date.new(2016,7,1),Date.new(2017,3,5))
  end
  puts "Running EXPA #{job} starting #{Time.now}"
end

# Define the schedule
every(3.day, 'opportunities')
#every(3.day, 'oGE')
#every(3.day, 'oGT')
#every(3.day, 'iGV')
#every(3.day, 'iGE')
#every(3.day, 'iGT')
#every(3.day, 'oGV')
