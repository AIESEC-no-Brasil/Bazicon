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

  def test_list_all_leads

    host = Host.new 
    host.full_name = "Free 1"
    host.tmp_responsable_id = 124535
    host.date_approach = "2016-04-10 12:29:29"
    host.date_alignment_meeting = "2016-04-10 12:29:29"
    host.tmp_who_realized_meeting_id = 345632
    host.is_favourite = false
    host.is_problematic = false
    host.save

    host = Host.new 
    host.full_name = "Free 2"
    host.tmp_responsable_id = 856886
    host.date_approach = "2016-04-10 12:12:29"
    host.date_alignment_meeting = "2016-04-10 10:29:29"
    host.tmp_who_realized_meeting_id = 345632
    host.is_favourite = false
    host.is_problematic = false
    host.save

    host = Host.new 
    host.full_name = "Lead 1"
    host.tmp_responsable_id = 856886
    host.save

    host = Host.new 
    host.full_name = "Lead 2"
    host.tmp_responsable_id = 856886
    host.tmp_who_realized_meeting_id = 345632
    host.is_favourite = false
    host.is_problematic = false
    host.save

    host = Host.new 
    host.full_name = "Lead 3"
    host.tmp_responsable_id = 856886
    host.tmp_who_realized_meeting_id = 345632
    host.is_favourite = false
    host.is_problematic = false
    host.save

    list = Hosts.list_leads

    assert(list.length == 3, "Retornou o número errado de leads, ŕetornou #{list.count} pessoas e devieria ser 3")
  end

  def test_list_all_problematics
    hosts = Hosts.list_problematics
    assert(hosts.count == 0, "Retornou valor qndo não deveria. Retornou #{hosts.count.to_s} e deveria retonar 0")
  
    host = Host.new
    host.full_name = "queridinho 1"
    host.save

    host = Host.new
    host.full_name = "queridinho 2"
    host.save

    hosts = Hosts.list_problematics
    assert(hosts.count == 0, "Retornou valor qndo não deveria. Retornou #{hosts.count.to_s} e deveria retonar 0")
  
    host = Host.new
    host.full_name = "problematico 1"
    host.is_problematic = true
    host.save

    hosts = Hosts.list_problematics
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