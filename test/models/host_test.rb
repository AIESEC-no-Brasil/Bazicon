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
    assert(hosts.count == 0, "Assert 1) Wrong number of hosts. It was supposed to be 0, it got #{hosts} instead")

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
    assert(hosts.count == 0, "Assert 2) Wrong number of hosts. It was supposed to be 0, it got #{hosts} instead")


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