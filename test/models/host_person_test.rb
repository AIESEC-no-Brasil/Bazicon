require 'test_helper'

class HostPersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
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
  	person = HostPerson.new
  	person.full_name = "Fulano de tal"
  	person.save
  	assert person.destroy, "Não deletou o usuário"
  end

  def teardown 
  end
end
