# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Leads = Host.create([{full_name: "Lead 1"}])
tags = Tag.create([{ name: 'TM' }, { name: 'ICX' },{ name: 'OGX' },{ name: 'GCDP' },{ name: 'GIP' }, { name: 'FIN' },
                   { name: 'MKT' },{ name: 'OUTPUT' },{ name: 'APRESENTAÇÃO' },{name: 'TREINAMENTO' },
                   {name: 'FERRAMENTA'}, {name: 'RELATÒRIO'}   ])

(1..3).each do |i|
  person = HostPerson.new
  person.full_name = "Free #{i}"
  person.phone = 91239
  person.email = "mail.@mail.com"
  person.address = "12 stree, 180"
  person.tmp_responsable_id = 78789
  person.tmp_who_realized_meeting_id = 79887
  person.date_approach = Time.new(2016,4,10)
  person.date_alignment_meeting = Time.new(Time.now.year,Time.now.month, Time.now.day-2)
  person.save
end

(4..6).each do |i|
  person = HostPerson.new
  person.full_name = "Lead #{i}"
  person.phone = 91239
  person.email = "mail.@mail.com"
  person.address = "12 stree, 180"
  person.date_alignment_meeting = Time.new(Time.now.year,Time.now.month, Time.now.day+2)
  person.nearest_lc_id = 434
  person.is_favourite = true
  person.save
end

(10..13).each do |i|
  person = HostPerson.new
  person.full_name = "Lead #{i}"
  person.phone = 91239
  person.email = "mail.@mail.com"
  person.address = "12 stree, 180"
  person.date_alignment_meeting = Time.new(Time.now.year,Time.now.month, Time.now.day+2)
  person.nearest_lc_id = 434
  person.is_problematic = true
  person.save
end

(30..50).each do |i|
  host = HostPerson.new
  host.full_name = "Allocated #{i}"
  host.phone = 91239
  host.email = "mail.@mail.com"
  host.address = "12 stree, 180"
  host.tmp_responsable_id = 78789
  host.tmp_who_realized_meeting_id = 79887
  host.date_approach = Time.new(2016,4,10)
  host.date_alignment_meeting = Time.new(Time.now.year,Time.now.month, Time.now.day-2)
  host.nearest_lc_id = 434
  host.trainees_vacancy = 2
  host.save
  trainee = TraineePerson.new
  trainee.full_name = "Trainee #{i}"
  trainee.entry_date = Time.new(Time.now.year,Time.now.month, Time.now.day-2)
  trainee.save
  t2h = TraineeToHost.new
  
  trainee2host = TraineeToHost.new
  trainee2host.host_person_id = host.id
  trainee2host.trainee_person_id = trainee.id
  trainee2host.entry_date = trainee.entry_date
  trainee2host.save
end



