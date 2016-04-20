require 'minitest/autorun'

class HostTest < Minitest::Test
  def setup
  end

  def teardown
    Archive.all.each do |archive|
      archive.destroy
    end
    ExpaApplication.all.each do |application|
      application.destroy
    end
    ExpaCurrentPosition.all.each do |current_position|
      current_position.destroy
    end
    ExpaOffice.all.each do |office|
      office.destroy
    end
    ExpaOpportunity.all.each do |opportuniy|
      opportuniy.destroy
    end
    ExpaPerson.all.each do |person|
      person.destroy
    end
    ExpaTeam.all.each do |team|
      team.destroy
    end
    Host.all.each do |host|
      host.destroy
    end
  end

  def test_save
  	person = Host.new
  	person.full_name = "Fulano de tal"
  	person.phone = 91239
  	person.email = "mail.@mail.com"
  	person.address = "12 stree, 180"
  	assert person.save, "Não Salvou"
  end

  def test_delete 
  	person = Host.new
  	person.full_name = "Fulano de tal"
  	person.save
  	assert person.destroy, "Não deletou o usuário"
  end

  def test_list_all_free
    hosts = Host.list_free
    assert(hosts.length == 0, "List Free Assert 1) Wrong number of hosts. It was supposed to be 0, it got #{hosts.count} instead")

    #creating leads that doesn't have tmp responsable or for realize
    lead = Host.new
    lead.full_name = "Lead 1"
    lead.tmp_responsable_id = 78789
    lead.save

    lead = Host.new
    lead.full_name = "Lead 2"
    lead.tmp_who_realized_meeting_id = 79887
    lead.save

    lead = Host.new
    lead.full_name = "Lead 3"
    lead.save

    hosts = Host.list_free
    assert(hosts.count == 0, "List Free Assert 2) Wrong number of hosts. It was supposed to be 0, it got #{hosts.count} instead")

    #lead with date_alignment_meeting < Time.now
    lead = Host.new
    lead.full_name = "Lead 4"
    lead.tmp_responsable_id = 78789
    lead.tmp_who_realized_meeting_id = 79887
    lead.date_approach = Time.new(2016,4,10)
    lead.date_alignment_meeting = Time.new(2016,4,Time.now.day+2)
    lead.save

    hosts = Host.list_free
    assert(hosts.count == 0, "List Free Assert 3) Wrong number of hosts. It was supposed to be 0, it got #{hosts.count} instead")

    #host free with date_alignment_meeting < Time.now
    free = Host.new
    free.full_name = "Free 1"
    free.tmp_responsable_id = 78789
    free.tmp_who_realized_meeting_id = 79887
    free.date_approach = Time.new(2016,4,10)
    free.date_alignment_meeting = Time.new(2016,4,Time.now.day - 3)
    free.save

    hosts = Host.list_free
    assert(hosts.count == 1, "List Free Assert 4) Wrong number of hosts. It was supposed to be 1, it got #{hosts.count} instead")

    (1..10).each do |i|
      free = Host.new 
      free.full_name = "Free #{i}"
      free.tmp_responsable_id = 78789
      free.tmp_who_realized_meeting_id = 79887
      free.date_approach = Time.new(2016,4,10)
      free.date_alignment_meeting = Time.new(2016,4,0+i)
      free.save
    end

    hosts = Host.list_free
    assert(hosts.count == 10+1, "Assert 5) It shoul read 10 free hosts. It read #{hosts.count} instead")


  end
  
  def test_list_all_leads
    hosts_leads = Host.list_leads
    assert(hosts_leads.count == 0, "List Leads=>Assert 1) Wrong number of hosts. It was supposed to be 0, it got #{hosts_leads.count} instead")

    (1..10).each do |i|
      free = Host.new 
      free.full_name = "Free #{i}"
      free.tmp_responsable_id = 78789
      free.tmp_who_realized_meeting_id = 79887
      free.date_approach = Time.new(2016,4,10)
      free.date_alignment_meeting = Time.new(2016,4,0+i)
      free.save
    end

    hosts_leads = Host.list_leads
    assert(hosts_leads.count == 0, "List Leads=>Assert 2) Wrong number of hosts. It was supposed to be 0, it got #{hosts_leads.count} instead")
    
    lead = Host.new
    lead.full_name = "Lead 1"
    lead.tmp_responsable_id = 78789
    lead.tmp_who_realized_meeting_id = 79887
    lead.date_approach = Time.new(2016,4,10)
    lead.date_alignment_meeting = Time.new(2016,4,Time.now.day + 1)
    lead.save

    lead = Host.new
    lead.full_name = "Lead 2"
    lead.tmp_responsable_id = 78789
    lead.tmp_who_realized_meeting_id = 79887
    lead.date_approach = Time.new(2016,4,10)
    lead.date_alignment_meeting = Time.new(2016,4,Time.now.day + 2)
    lead.save

    hosts_leads = Host.list_leads
    assert(hosts_leads.count == 2, "List Leads=>Assert 3) Wrong number of hosts. It was supposed to be 2, it got #{hosts_leads.count} instead")

    Host.all.each do |host|
      host.destroy
    end

    (1..100).each do |i|
      lead = Host.new 
      lead.full_name = "Lead #{i}"
      lead.tmp_responsable_id = 78789
      lead.tmp_who_realized_meeting_id = 79887
      #no date_approach
      lead.date_alignment_meeting = Time.new(2016,4,10)
      lead.save
    end

    hosts_leads = Host.list_leads
    assert(hosts_leads.count == 100, "List Leads=>Assert 4) Wrong number of hosts. It was supposed to be 100, it got #{hosts_leads.count} instead")

  end
  
  def test_list_all_problematics
    hosts = Host.list_problematics
    assert(hosts.count == 0, "Retornou valor qndo não deveria. Retornou #{hosts.count.to_s} e deveria retonar 0")
  
    host = Host.new
    host.full_name = "queridinho 1"
    host.save

    host = Host.new
    host.full_name = "queridinho 2"
    host.save

    hosts = Host.list_problematics
    assert(hosts.count == 0, "Retornou valor qndo não deveria. Retornou #{hosts.count.to_s} e deveria retonar 0")
  
    host = Host.new
    host.full_name = "problematico 1"
    host.is_problematic = true
    host.save

    hosts = Host.list_problematics
    assert(hosts.count == 1, "Retornou valor qndo não deveria. Retornou #{hosts.count.to_s} e deveria retonar 1")
  
    host = Host.new
    host.full_name = "problematico 2"
    host.is_problematic = true
    host.save

    host = Host.new
    host.full_name = "problematico 3"
    host.is_problematic = true
    host.save

    host = Host.new
    host.full_name = "problematico 4"
    host.is_problematic = true
    host.save    

    assert(hosts.count == 4, "Retornou valor qndo não deveria. Retornou #{hosts.count.to_s} e deveria retonar 4")
  end
end