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

    hosts = HostPerson.list_free
    assert(hosts.length == 0, "List Free Assert 1) Wrong number of hosts. It was supposed to be 0, it got #{hosts.count} instead")

    (1..10).each do |i|
	  	person = HostPerson.new
	  	person.full_name = "Lead #{i}"
	  	person.phone = 91239
	  	person.email = "mail.@mail.com"
	  	person.address = "12 stree, 18#{i}"
	  	person.save
	end 

	(1..10).each do |i|
		person = HostPerson.new
	  	person.full_name = "Lead #{i}"
	  	person.phone = 91239
	  	person.email = "mail.@mail.com"
	  	person.address = "12 stree, 18#{i}"
	  	person.tmp_responsable_id = 78789
    	person.tmp_who_realized_meeting_id = 79887
    	person.date_approach = Time.new(2016,4,10)
    	person.date_alignment_meeting = 78789
	  	person.save
	end

    hosts = HostPerson.list_free
    assert(hosts.length == 0, "List Free Assert 2) Wrong number of hosts. It was supposed to be 0, it got #{hosts.count} instead")

 	person = HostPerson.new
  	person.full_name = "Lead Com reunião Por Fazer"
  	person.phone = 91239
  	person.email = "mail.@mail.com"
  	person.address = "12 stree, 180"
  	person.tmp_responsable_id = 78789
	person.tmp_who_realized_meeting_id = 79887
	person.date_approach = Time.new(2016,4,10)
	person.date_alignment_meeting = 78789
	date_alignment_meeting = Time.new(Time.now.year,Time.now.month, Time.now.day+2)
  	person.save
  	
    hosts = HostPerson.list_free
    assert(hosts.length == 0, "List Free Assert 3) Wrong number of hosts. It was supposed to be 0, it got #{hosts.count} instead")

 	(1..5).each do |i|
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

    hosts = HostPerson.list_free
    assert(hosts.length == 5, "List Free Assert 4) Wrong number of hosts. It was supposed to be 5, it got #{hosts.count} instead")

    HostPerson.all.each do |host|
      host.destroy
    end

    (1..3).each do |i|
	    person = HostPerson.new
	  	person.full_name = "Lead Com reunião Por Fazer #{i}"
	  	person.phone = 91239
	  	person.email = "mail.@mail.com"
	  	person.address = "12 stree, 180"
	  	person.tmp_responsable_id = 78789
		person.tmp_who_realized_meeting_id = 79887
		person.date_approach = Time.new(2016,4,10)
		person.date_alignment_meeting = 78789
		date_alignment_meeting = Time.new(Time.now.year,Time.now.month, Time.now.day+2)
	  	person.save
  	end

  	(1..3).each do |i|
		person = HostPerson.new
	  	person.full_name = "Lead #{i}"
	  	person.phone = 91239
	  	person.email = "mail.@mail.com"
	  	person.address = "12 stree, 18#{i}"
	  	person.tmp_responsable_id = 78789
    	person.tmp_who_realized_meeting_id = 79887
    	person.date_approach = Time.new(2016,4,10)
    	person.date_alignment_meeting = 78789
	  	person.save
	end

	(1..5).each do |i|
	  	person = HostPerson.new
	  	person.full_name = "Lead #{i}"
	  	person.phone = 91239
	  	person.email = "mail.@mail.com"
	  	person.address = "12 stree, 18#{i}"
	  	person.save
	end

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

	hosts = HostPerson.list_free
    assert(hosts.length == 3, "List Free Assert 5) Wrong number of hosts. It was supposed to be >>3<<, it got >>#{hosts.count}<< instead")


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

end
