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

  def test_list_all_free
    hosts = HostPerson.list_free
    assert(hosts.length == 0, "List Free Assert 1) Wrong number of hosts. It was supposed to be 0, it got #{hosts.count} instead")
  end

end
