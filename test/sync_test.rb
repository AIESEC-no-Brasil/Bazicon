require 'minitest/autorun'
require 'uri'

class SyncTest < Minitest::Test
  def setup
    if EXPA.client.nil?
      xp = EXPA.setup()
      xp.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])
    end

    SyncControl.new do |sync|
      sync.start_sync = DateTime.now - 0.2
      sync.sync_type = 'open_people'
      sync.end_sync = DateTime.now
      sync.get_error = false
      sync.count_itens = 10
      sync.save
    end
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
    SyncControl.all.each do |sync|
      sync.destroy
    end
  end

=begin
  def test_api_call
    params = {'per_page' => 500}
    params['filters['+'experience_end_date'+'][from]'] = Date.today.to_s
    params['filters['+'experience_end_date'+'][to]'] = Date.today.to_s
    params['filters[person_home_mc][]'] = 1606 #from MC Brazil
    params['filters[opportunity_programme][]'] = 1 #GCDP
    params['access_token'] = '83bcb5013acc57f07b5dfdd824c86826271d16f36559e0f9de80b5871edd1ecc' #GCDP
    uri = URI('https://gis-api.aiesec.org:443/v1/applications.json')
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get(uri)
    res = JSON.parse(res) unless res.nil?
    puts res
    #total_items = EXPA::Applications.list_by_param(params)
  end
  def test_list_opens
    assert(ExpaPerson.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaPerson.all.count.to_s)
    Sync.new.get_new_people_from_expa
    assert(ExpaPerson.all.count > 1, 'DB should have more than 1 register, but it has ' + ExpaPerson.all.count.to_s)
  end

  def test_list_applieds
    assert(ExpaApplication.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaApplication.all.count.to_s)
    Sync.new.update_status('open', [1])
    assert(ExpaApplication.all.count > 1, 'DB should have more than 1 register, but it has ' + ExpaApplication.all.count.to_s)
  end

  def test_list_accepteds
    assert(ExpaApplication.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaApplication.all.count.to_s)
    Sync.new.update_status('accepted', [1])
    assert(ExpaApplication.all.count > 1, 'DB should have more than 1 register, but it has ' + ExpaApplication.all.count.to_s)
  end

  def test_list_in_progress
    assert(ExpaApplication.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaApplication.all.count.to_s)
    Sync.new.update_status('in_progress', [1])
    assert(ExpaApplication.all.count > 1, 'DB should have more than 1 register, but it has ' + ExpaApplication.all.count.to_s)
  end

  def test_list_approveds
    assert(ExpaApplication.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaApplication.all.count.to_s)
    Sync.new.update_status('approved', [1])
    assert(ExpaApplication.all.count > 1, 'DB should have more than 1 register, but it has ' + ExpaApplication.all.count.to_s)
  end

  def test_list_realizeds
    assert(ExpaApplication.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaApplication.all.count.to_s)
    Sync.new.update_status('realized', [1])
    assert(ExpaApplication.all.count > 1, 'DB should have more than 1 register, but it has ' + ExpaApplication.all.count.to_s)
  end

  def test_list_completeds
    assert(ExpaApplication.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaApplication.all.count.to_s)
    Sync.new.update_status('completed', [1])
    assert(ExpaApplication.all.count > 1, 'DB should have more than 1 register, but it has ' + ExpaApplication.all.count.to_s)
  end
=end
  def test_update_podio_with_new_fields
    assert(ExpaApplication.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaApplication.all.count.to_s)
    ExpaOffice.new(id:20,xp_full_name:'AIESEC in Aracaju',xp_id:100,xp_name:'ARACAJU').save
    ExpaPerson.new(xp_id:299099230,xp_full_name: 'Robozinho dos testes',xp_email: 'robozobo@hahahah',how_got_to_know_aiesec:18,
      want_contact_by_email: true,want_contact_by_phone: false, want_contact_by_whatsapp: true,travel_interest:3,
      control_podio:'{}',entity_exchange_lc_id:20).save
    Sync.new.update_podio
  end
end


  
