# Tests concerning to business logic must be tested. Not working yet, except List Free
require 'minitest/autorun'

class HostPersonTest < ActiveSupport::TestCase
  def setup
  end

  def teardown
  	HostPerson.all.each do |host|
      host.destroy
    end
  end

  def test_save
  	person = HostPerson.new
  	person.full_name = "Fulano de tal"
  	person.phone = 91239
  	person.email = "mail.@mail.com"
  	person.address = "12 stree, 180"
  	assert person.save, "Não Salvou"
  end

  def test_delete
  	
  	HostPerson.all.each do |host|
      host.destroy
    end

  	person = HostPerson.new
  	person.full_name = "Fulano de tal"
  	person.phone = 91239
  	person.email = "mail.@mail.com"
  	person.address = "12 stree, 180"
  	person.save
  	assert person.destroy, "Não deletou"
  end

  def test_list_free
  	HostPerson.all.each do |host|
      host.destroy
    end

    hosts = HostPerson.list_leads
    assert(hosts.count == 0, "List Free Assert 1) Wrong number of leads. It should take 0 but took #{hosts.count} instead!")

  end

  def test_list_leads
    HostPerson.all.each do |host|
      host.destroy
    end

  	hosts = HostPerson.list_leads
  	assert(hosts.count == 0, "List Leads Assert 1) Wrong number of leads. It should take 0 but took #{hosts.count} instead!")
  		
  	(1..3).each do |i|
	 	person = HostPerson.new
  	person.full_name = "Free #{i}"
  	person.phone = 91239
  	person.email = "mail.@mail.com"
  	person.address = "12 stree, 180"
  	person.tmp_responsable_id = 78789
	  person.tmp_who_realized_meeting_id = 79887
		person.date_approach = Time.new(2016,4,10)
		person.date_alignment_meeting = 78789
		person.date_alignment_meeting = Time.new(Time.now.year,Time.now.month, Time.now.day-2)
  	person.save
	end

  	hosts = HostPerson.list_leads
  	assert(hosts.count == 0, "List Leads Assert 2) Wrong number of leads. It should take 0 but took #{hosts.count} instead!")

  	
 	person = HostPerson.new
  	person.save


	leads = HostPerson.all
	assert(hosts.count == 1, "List Leads Assert 3) Wrong number of leads. It should take 1 but took #{hosts.count} instead!")
  end

  def test_list_free
    HostPerson.all.each do |host|
      host.destroy
    end

    hosts = HostPerson.list_free
    assert(hosts.count == 0, "List Leads Assert 1) Wrong number of leads. It should take 0 but took #{hosts.count} instead!")

    (1..3).each do |i|
      host = HostPerson.new 
      host.tmp_responsable_id = 1
      host.tmp_who_realized_meeting_id = 1
      host.date_approach = Time.new(2016,2,5)
      host.date_alignment_meeting = Time.new(2016, 2, 28)
      host.save

      t2h = TraineeToHost.new
      t2h.host_person_id = host.id
      t2h.trainee_person_id = 542423
      t2h.save
    end

    hosts = HostPerson.list_free
    assert(hosts.count == 3, "List Leads Assert 2) Wrong number of leads. It should take 0 but took #{hosts.count} instead!")

  end

end
