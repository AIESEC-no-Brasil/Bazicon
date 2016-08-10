require 'clockwork'

# Require the full rails environment if needed
require './config/boot'
require './config/environment'

include Clockwork

# Define the jobs
handler do |job|
  if job.eql?('list new open people')
    Sync.new.get_new_people_from_expa
  elsif job.eql?('list new open applications and update people')
    Sync.new.update_status('created_at',[1])
  elsif job.eql?('list new accepted applications and update people')
    Sync.new.update_status('date_matched',[1])
  elsif job.eql?('list new in progress applications and update people')
    Sync.new.update_status('date_an_signed',[1])
  elsif job.eql?('list new approved applications and update people')
    Sync.new.update_status('date_approved',[1])
  elsif job.eql?('list new realized applications and update people')
    Sync.new.update_status('experience_start_date',[1])
  elsif job.eql?('list new completed applications and update people')
    Sync.new.update_status('experience_end_date',[1])
  end
  puts "Running EXPA #{job} starting #{Time.now}"
end

# Define the schedule
every(20.minutes, 'list new open people')
every(4.hours, 'list new open applications and update people')
every(3.hours, 'list new accepted applications and update people')
every(3.hours, 'list new in progress applications and update people')
every(3.hours, 'list new approved applications and update people')
every(3.hours, 'list new realized applications and update people')
every(3.hours, 'list new completed applications and update people')