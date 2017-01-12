require 'clockwork'

# Require the full rails environment if needed
require './config/boot'
require './config/environment'

include Clockwork

# Define the jobs
handler do |job|
  if job.eql?('list new open people')
    # Sync.new.get_new_people_from_expa
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "get_new_people_from_expa" })
  elsif job.eql?('list new open applications and update people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "open", "programs" => "1", "for_filter" => "people" } })
    # Sync.new.update_status('open',[1],'people')
  elsif job.eql?('list new accepted applications and update people')
    Sync.new.update_status('accepted',[1],'people')
  elsif job.eql?('list new in progress applications and update people')
    Sync.new.update_status('in_progress',[1],'people')
  elsif job.eql?('list new approved applications and update people')
    Sync.new.update_status('approved',[1],'people')
  elsif job.eql?('list new realized applications and update people')
    Sync.new.update_status('realized',[1],'people')
  elsif job.eql?('list new completed applications and update people')
    Sync.new.update_status('completed',[1],'people')

  elsif job.eql?('list new open applications and update GT people')
    Sync.new.update_status('open',[2],'people')
  elsif job.eql?('list new accepted applications and update GT people')
    Sync.new.update_status('accepted',[2],'people')
  elsif job.eql?('list new in progress applications and update GT people')
    Sync.new.update_status('in_progress',[2],'people')
  elsif job.eql?('list new approved applications and update GT people')
    Sync.new.update_status('approved',[2],'people')
  elsif job.eql?('list new realized applications and update GT people')
    Sync.new.update_status('realized',[2],'people')
  elsif job.eql?('list new completed applications and update GT people')
    Sync.new.update_status('completed',[2],'people')

  elsif job.eql?('list new open applications and update GE people')
    Sync.new.update_status('open',[5],'people')
  elsif job.eql?('list new accepted applications and update GE people')
    Sync.new.update_status('accepted',[5],'people')
  elsif job.eql?('list new in progress applications and update GE people')
    Sync.new.update_status('in_progress',[5],'people')
  elsif job.eql?('list new approved applications and update GE people')
    Sync.new.update_status('approved',[5],'people')
  elsif job.eql?('list new realized applications and update GE people')
    Sync.new.update_status('realized',[5],'people')
  elsif job.eql?('list new completed applications and update GE people')
    Sync.new.update_status('completed',[5],'people')

  elsif job.eql?('list new open applications and update opportunities')
    Sync.new.update_status('open',[1],'opportunities')
  elsif job.eql?('list new accepted applications and update opportunities')
    Sync.new.update_status('accepted',[1],'opportunities')
  elsif job.eql?('list new in progress applications and update opportunities')
    Sync.new.update_status('in_progress',[1],'opportunities')
  elsif job.eql?('list new approved applications and update opportunities')
    Sync.new.update_status('approved',[1],'opportunities')
  elsif job.eql?('list new realized applications and update opportunities')
    Sync.new.update_status('realized',[1],'opportunities')
  elsif job.eql?('list new completed applications and update opportunities')
    Sync.new.update_status('completed',[1],'opportunities')
  elsif job.eql?('send data to OD')
    Sync.new.send_to_od
  elsif job.eql?('list all applications and update people')
    Sync.new.search_problematic_applications(Date.new(2016,7,1),Date.new(2016,8,26))
  end
  puts "Running EXPA #{job} starting #{Time.now}"
end

# Define the schedule
every(6.hours, 'list new open people')

every(4.hours, 'list new open applications and update people')
every(3.hours, 'list new accepted applications and update people')
every(3.hours, 'list new in progress applications and update people')
every(3.hours, 'list new approved applications and update people')
every(8.hours, 'list new realized applications and update people')
every(8.hours, 'list new completed applications and update people')

every(4.hours, 'list new open applications and update GT people')
every(3.hours, 'list new accepted applications and update GT people')
every(3.hours, 'list new in progress applications and update GT people')
every(3.hours, 'list new approved applications and update GT people')
every(8.hours, 'list new realized applications and update GT people')
every(8.hours, 'list new completed applications and update GT people')

every(4.hours, 'list new open applications and update GE people')
every(3.hours, 'list new accepted applications and update GE people')
every(3.hours, 'list new in progress applications and update GE people')
every(3.hours, 'list new approved applications and update GE people')
every(8.hours, 'list new realized applications and update GE people')
every(8.hours, 'list new completed applications and update GE people')
every(4.hours, 'list new open applications and update GE people')

every(4.hours, 'list new open applications and update opportunities')
every(3.hours, 'list new accepted applications and update opportunities')
every(3.hours, 'list new accepted applications and update opportunities')
every(3.hours, 'list new in progress applications and update opportunities')
every(3.hours, 'list new approved applications and update opportunities')
every(8.hours, 'list new realized applications and update opportunities')
every(8.hours, 'list new completed applications and update opportunities')

every(1.day, 'send data to OD', :at => '03:00')
#every(1.day, 'list all applications and update people', :at => '16:48')
