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

  def test_list_leads
    HostPerson.all.each do |host|
      host.destroy
    end

    hosts = HostPerson.list_leads
  	assert(hosts.count == 0, "List Leads Assert 1) Wrong number of leads. It should take 0 but took #{hosts.count} instead!")
    #Creating a free Person
    host = HostPerson.new 
    host.tmp_responsable_id = 1
    host.tmp_who_realized_meeting_id = 1
    host.date_approach = Time.new(2016,2,5)
    host.date_alignment_meeting = Time.new(2016, 2, 28)
    host.save

    hosts = HostPerson.list_leads
    assert(hosts.count == 0, "List Leads Assert 2) Wrong number of leads. It should take 0 but took #{hosts.count} instead!")
    
    #Creating leads hosts
    host = HostPerson.new 
    host.tmp_responsable_id = nil
    host.tmp_who_realized_meeting_id = 1
    host.date_approach = Time.new(2016,2,5)
    host.date_alignment_meeting = Time.new(2016, 2, 28)
    host.save

    hosts = HostPerson.list_leads
    assert(hosts.count == 1, "List Leads Assert 3) Wrong number of leads. It should take 0 but took #{hosts.count} instead! #{host.tmp_who_realized_meeting_id}")

    host = HostPerson.new 
    host.tmp_responsable_id = 1
    host.tmp_who_realized_meeting_id = nil
    host.date_approach = Time.new(2016,2,5)
    host.date_alignment_meeting = Time.new(2016, 2, 28)
    host.save

    hosts = HostPerson.list_leads
    assert(hosts.count == 2, "List Leads Assert 4) Wrong number of leads. It should take 0 but took #{hosts.count} instead!")
  
    host = HostPerson.new 
    host.tmp_responsable_id = 1
    host.tmp_who_realized_meeting_id = 1
    host.date_approach = nil
    host.date_alignment_meeting = Time.new(2016, 2, 28)
    host.save

    hosts = HostPerson.list_leads
    assert(hosts.count == 3, "List Leads Assert 5) Wrong number of leads. It should take 0 but took #{hosts.count} instead!")

    host = HostPerson.new 
    host.tmp_responsable_id = 1
    host.tmp_who_realized_meeting_id = 1
    host.date_approach = Time.new(2016,2,5)
    host.date_alignment_meeting = Time.new(2016, Time.now.month + 1, 28)
    host.save

    hosts = HostPerson.list_leads
    assert(hosts.count == 4, "List Leads Assert 6) Wrong number of leads. It should take 0 but took #{hosts.count} instead!")

  end

end
