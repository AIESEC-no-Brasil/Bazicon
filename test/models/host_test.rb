require 'minitest/autorun'

class HostTest < Minitest::Test
  # test "the truth" do
  #   assert true
  # end

  def setup
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
    hosts = HostDAO.list_leads
    assert(hosts.count == 0, "Retornou valor qndo não deveria. Retornou " + hosts.count.to_s + " e deveria retonar 0")
  
    host = Host.new
    host.full_name = "nao lead 1"
    host.is_problematic = true
    host.save

    host = Host.new
    host.full_name = "nao lead 2"
    host.is_non_grata = true
    host.save

    hosts = HostDAO.list_leads
    assert(hosts.count == 0, "Retornou valor qndo não deveria. Retornou " + hosts.count.to_s + " e deveria retonar 0")
  
    host = Host.new
    host.full_name = "lead 1"
    host.save

    hosts = HostDAO.list_leads
    assert(hosts.count == 1, "Retornou valor qndo não deveria. Retornou " + hosts.count.to_s + " e deveria retonar 1")
  
    host = Host.new
    host.full_name = "lead 2"
    host.save

    host = Host.new
    host.full_name = "lead 3"
    host.save

    host = Host.new
    host.full_name = "nao lead 3"
    host.date_approach = Time.new
    host.date_alignment_meeting = Time.new
    host.tmp_who_realized_meeting_id = 1
    host.tmp_responsable_id = 1
    host.save  

    host = Host.new
    host.full_name = "nao lead 4"
    host.is_favourite = true
    host.save
    
    assert(hosts.count == 3, "Retornou valor qndo não deveria. Retornou " + hosts.count.to_s + " e deveria retonar 3")
  end

  def test_list_all_problematics
    hosts = HostDAO.list_problematics
    assert(hosts.count == 0, "Retornou valor qndo não deveria. Retornou " + hosts.count.to_s + " e deveria retonar 0")
  
    host = Host.new
    host.full_name = "queridinho 1"
    host.save

    host = Host.new
    host.full_name = "queridinho 2"
    host.save

    hosts = HostDAO.list_problematics
    assert(hosts.count == 0, "Retornou valor qndo não deveria. Retornou " + hosts.count.to_s + " e deveria retonar 0")
  
    host = Host.new
    host.full_name = "problematico 1"
    host.is_problematic = true
    host.save

    hosts = HostDAO.list_problematics
    assert(hosts.count == 1, "Retornou valor qndo não deveria. Retornou " + hosts.count.to_s + " e deveria retonar 1")
  
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

    assert(hosts.count == 4, "Retornou valor qndo não deveria. Retornou " + hosts.count.to_s + " e deveria retonar 4")
  end

  def teardown 
    ExpaPerson.all.each do |person|
      person.destroy
    end
    ExpaApplication.all.each do |application|
      application.destroy
    end
    ExpaOffice.all.each do |office|
      office.destroy
    end
    ExpaOpportunity.all.each do |opportunity|
      opportunity.destroy
    end
    Host.all.each do |host|
      host.destroy
    end
  end
end
