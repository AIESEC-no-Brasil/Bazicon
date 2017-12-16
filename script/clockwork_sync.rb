require 'clockwork'

# Require the full rails environment if needed
require './config/boot'
require './config/environment'

include Clockwork

# Define the jobs
handler do |job|
  if job.eql?('oGV')
    puts 'created_at'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"people",'created_at')
    puts 'date_matched'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"people",'date_matched')
    puts 'date_an_signed'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"people",'date_an_signed')
    puts 'date_approved'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"people",'date_approved')
    puts 'date_realized'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"people",'date_realized')
    puts 'experience_start_date'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"people",'experience_start_date')
    puts 'experience_end_date'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"people",'experience_end_date')
  elsif job.eql?('oGE')
    puts 'created_at'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"people",'created_at')
    puts 'date_matched'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"people",'date_matched')
    puts 'date_an_signed'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"people",'date_an_signed')
    puts 'date_approved'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"people",'date_approved')
    puts 'date_realized'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"people",'date_realized')
    puts 'experience_start_date'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"people",'experience_start_date')
    puts 'experience_end_date'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"people",'experience_end_date')
  elsif job.eql?('oGT')
    puts 'created_at'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"people",'created_at')
    puts 'date_matched'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"people",'date_matched')
    puts 'date_an_signed'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"people",'date_an_signed')
    puts 'date_approved'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"people",'date_approved')
    puts 'date_realized'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"people",'date_realized')
    puts 'experience_start_date'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"people",'experience_start_date')
    puts 'experience_end_date'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"people",'experience_end_date')
  elsif job.eql?('iGV')
    puts 'created_at'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"opportunities",'created_at')
    puts 'date_matched'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"opportunities",'date_matched')
    puts 'date_an_signed'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"opportunities",'date_an_signed')
    puts 'date_approved'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"opportunities",'date_approved')
    puts 'date_realized'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"opportunities",'date_realized')
    puts 'experience_start_date'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"opportunities",'experience_start_date')
    puts 'experience_end_date'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[1],"opportunities",'experience_end_date')
  elsif job.eql?('iGE')
    puts 'created_at'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"opportunities",'created_at')
    puts 'date_matched'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"opportunities",'date_matched')
    puts 'date_an_signed'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"opportunities",'date_an_signed')
    puts 'date_approved'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"opportunities",'date_approved')
    puts 'date_realized'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"opportunities",'date_realized')
    puts 'experience_start_date'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"opportunities",'experience_start_date')
    puts 'experience_end_date'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[5],"opportunities",'experience_end_date')
  elsif job.eql?('iGT')
    puts 'created_at'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"opportunities",'created_at')
    puts 'date_matched'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"opportunities",'date_matched')
    puts 'date_an_signed'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"opportunities",'date_an_signed')
    puts 'date_approved'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"opportunities",'date_approved')
    puts 'date_realized'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"opportunities",'date_realized')
    puts 'experience_start_date'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"opportunities",'experience_start_date')
    puts 'experience_end_date'
    ManualSync.new.check_problematic_applications(Date.new(2017,1,1),Date.new(2017,3,5),[2],"opportunities",'experience_end_date')
  elsif job.eql?('opportunities')
    ManualSync.new.check_problematic_opportunities(Date.new(2016,7,1),Date.new(2017,3,5))
  elsif job.eql?('update_opportunities_without_lc')
    ManualSync.new.update_opportunities_without_lc
  end
  puts "Running EXPA #{job} starting #{Time.now}"
end

# Define the schedule
every(1.day, 'update_opportunities_without_lc')
every(2.day, 'opportunities')
every(2.day, 'iGE')
every(2.day, 'iGT')
every(2.day, 'iGV')
every(2.day, 'oGE')
every(2.day, 'oGT')
every(2.day, 'oGV')
