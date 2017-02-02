require 'clockwork'

# Require the full rails environment if needed
require './config/boot'
require './config/environment'

include Clockwork

# Define the jobs
handler do |job|
  if job.eql?('list new open people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "get_new_people_from_expa" })
  elsif job.eql?('list new open applications and update people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "open", "programs" => "1", "for_filter" => "people" } })
  elsif job.eql?('list new accepted applications and update people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "accepted", "programs" => "1", "for_filter" => "people" } })
  elsif job.eql?('list new in progress applications and update people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "in_progress", "programs" => "1", "for_filter" => "people" } })
  elsif job.eql?('list new approved applications and update people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "approved", "programs" => "1", "for_filter" => "people" } })
  elsif job.eql?('list new realized applications and update people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "realized", "programs" => "1", "for_filter" => "people" } })
  elsif job.eql?('list new completed applications and update people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "completed", "programs" => "1", "for_filter" => "people" } })

  elsif job.eql?('list new open applications and update GT people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "open", "programs" => "2", "for_filter" => "people" } })
  elsif job.eql?('list new accepted applications and update GT people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "accepted", "programs" => "2", "for_filter" => "people" } })
  elsif job.eql?('list new in progress applications and update GT people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "in_progress", "programs" => "2", "for_filter" => "people" } })
  elsif job.eql?('list new approved applications and update GT people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "approved", "programs" => "2", "for_filter" => "people" } })
  elsif job.eql?('list new realized applications and update GT people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "realized", "programs" => "2", "for_filter" => "people" } })
  elsif job.eql?('list new completed applications and update GT people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "completed", "programs" => "2", "for_filter" => "people" } })

  elsif job.eql?('list new open applications and update GE people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "open", "programs" => "5", "for_filter" => "people" } })
  elsif job.eql?('list new accepted applications and update GE people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "accepted", "programs" => "5", "for_filter" => "people" } })
  elsif job.eql?('list new in progress applications and update GE people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "in_progress", "programs" => "5", "for_filter" => "people" } })
  elsif job.eql?('list new approved applications and update GE people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "approved", "programs" => "5", "for_filter" => "people" } })
  elsif job.eql?('list new realized applications and update GE people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "realized", "programs" => "5", "for_filter" => "people" } })
  elsif job.eql?('list new completed applications and update GE people')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "completed", "programs" => "5", "for_filter" => "people" } })

  elsif job.eql?('list new open applications and update opportunities')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "open", "programs" => "1", "for_filter" => "opportunities" } })
  elsif job.eql?('list new accepted applications and update opportunities')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "accepted", "programs" => "1", "for_filter" => "opportunities" } })
  elsif job.eql?('list new in progress applications and update opportunities')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "in_progress", "programs" => "1", "for_filter" => "opportunities" } })
  elsif job.eql?('list new approved applications and update opportunities')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "approved", "programs" => "1", "for_filter" => "opportunities" } })
  elsif job.eql?('list new realized applications and update opportunities')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "realized", "programs" => "1", "for_filter" => "opportunities" } })
  elsif job.eql?('list new completed applications and update opportunities')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "update_status", "params" => { "status" => "completed", "programs" => "1", "for_filter" => "opportunities" } })
  elsif job.eql?('send data to OD')
    SendJobDataToSqs.call({ "klass" => "Sync", "method" => "send_to_od" })
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

every(4.hours, 'list new open applications and update opportunities')
every(3.hours, 'list new accepted applications and update opportunities')
every(3.hours, 'list new accepted applications and update opportunities')
every(3.hours, 'list new in progress applications and update opportunities')
every(3.hours, 'list new approved applications and update opportunities')
every(8.hours, 'list new realized applications and update opportunities')
every(8.hours, 'list new completed applications and update opportunities')

#every(1.day, 'list all applications and update people', :at => '16:48')
