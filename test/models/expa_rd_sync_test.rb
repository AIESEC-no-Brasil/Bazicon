require 'minitest/autorun'

class ExpaRdSyncTest < Minitest::Test
  def setup
    if EXPA.client.nil?
      xp = EXPA.setup()
      xp.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])
      teardown
    end
  end

  def teardown
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end

  def test_insert_new_register_at_db
    assert(ExpaPerson.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaPerson.all.count.to_s)

    params = {'per_page' => 1}
    xp_person = EXPA::People.list_by_param(params).first
    xp_sync = ExpaRdSync.new
    xp_sync.update_db_peoples(xp_person)

    assert(ExpaPerson.all.count == 1, 'DB should have only 1 register, but it has ' + ExpaPerson.all.count.to_s)

    assert(ExpaApplication.all.count == 0, 'Db have registers. Make sure to clean DB before run tests, and it has ' + ExpaApplication.all.count.to_s)

    params = {'per_page' => 1}
    xp_application = EXPA::Applications.list_by_param(params).first
    xp_sync = ExpaRdSync.new
    xp_sync.update_db_applications(xp_application)
  end

  def test_update_people_that_are_already_on_db
    assert(ExpaPerson.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaPerson.all.count.to_s)

    params = {'per_page' => 2}
    xp_people = EXPA::People.list_by_param(params)
    xp_person = xp_people.first
    another_person = xp_people.second

    xp_sync = ExpaRdSync.new
    xp_sync.update_db_peoples(xp_person)
    assert(ExpaPerson.all.count == 1, 'DB should have only 1 register, but it has ' + ExpaPerson.all.count.to_s)

    xp_sync.update_db_peoples(xp_person)
    assert(ExpaPerson.all.count == 1, 'DB should have only 1 register, but it has ' + ExpaPerson.all.count.to_s)

    same_person = xp_person.clone
    same_person.full_name = xp_person.full_name + ' test'

    xp_sync.update_db_peoples(xp_person)
    assert(ExpaPerson.all.count == 1, 'DB should have only 1 register, but it has ' + ExpaPerson.all.count.to_s)
    xp_sync.update_db_peoples(same_person)
    assert(ExpaPerson.all.count == 1, 'DB should have only 1 register, but it has ' + ExpaPerson.all.count.to_s)
    #assert(ExpaPerson.first.xp_full_name == same_person.full_name, "DB didn' updated the register. Name should be '" + same_person.full_name + "' but it is '" + ExpaPerson.first.xp_full_name + "'") TODO check this test


    xp_sync.update_db_peoples(another_person)
    assert(ExpaPerson.all.count == 2, 'DB should have only 2 registers, but it has ' + ExpaPerson.all.count.to_s)

    assert(ExpaApplication.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaApplication.all.count.to_s)

    params = {'per_page' => 2}
    xp_applications = EXPA::Applications.list_by_param(params)
    xp_application = xp_applications.first
    another_xp_application = xp_applications.second

    xp_sync = ExpaRdSync.new
    xp_sync.update_db_applications(xp_application)
    assert(ExpaApplication.all.count == 1, 'DB should have only 1 register, but it has ' + ExpaApplication.all.count.to_s)

    xp_sync.update_db_applications(xp_application)
    assert(ExpaApplication.all.count == 1, 'DB should have only 1 register, but it has ' + ExpaApplication.all.count.to_s)

    same_xp_application = xp_application.clone
    same_xp_application.url = URI(xp_application.url.to_s + ' test')

    xp_sync.update_db_applications(xp_application)
    assert(ExpaApplication.all.count == 1, 'DB should have only 1 register, but it has ' + ExpaApplication.all.count.to_s)
    xp_sync.update_db_applications(same_xp_application)
    assert(ExpaApplication.all.count == 1, 'DB should have only 1 register, but it has ' + ExpaApplication.all.count.to_s)
    assert(ExpaApplication.first.url == same_xp_application.url, "DB didn' updated the register. Name should be " + same_xp_application.url + " but it is " + ExpaApplication.first.url)

    xp_sync.update_db_peoples(another_xp_application)
    assert(ExpaApplication.all.count == 2, 'DB should have only 2 registers, but it has ' + ExpaApplication.all.count.to_s)
  end

  def test_insert_every_application_from_person_at_db
    assert(ExpaPerson.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaPerson.all.count.to_s)
    assert(ExpaApplication.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaApplication.all.count.to_s)

    params = {'per_page' => 100, 'filters[status]' => 'in progress'}
    people = EXPA::People.list_by_param(params)

    for person in people do
      applications = EXPA::People.get_applications(person.id)
      break unless applications.empty? || applications.count == 0
    end

    xp_sync = ExpaRdSync.new
    xp_sync.update_db_peoples(person)

    assert(ExpaPerson.all.count == 1, 'DB should have only 1 register, but it has ' + ExpaPerson.all.count.to_s)
    assert(ExpaApplication.all.count > 0, 'Applications fomr user were not saved at database')
    assert(ExpaApplication.all.count == applications.count, 'DB should have ' + applications.count.to_s + ' registers , but it has ' + ExpaApplication.all.count.to_s)
  end

  def test_update_application_that_are_already_on_db
    assert(ExpaPerson.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaPerson.all.count.to_s)
    assert(ExpaApplication.all.count == 0, 'DB have registers. Make sure to clean DB before run tests, and it has ' + ExpaApplication.all.count.to_s)

    params = {'per_page' => 100, 'filters[status]' => 'in progress'}
    people = EXPA::People.list_by_param(params)

    for person in people do
      applications = EXPA::People.get_applications(person.id)
      break unless applications.empty? || applications.count == 0
    end

    xp_sync = ExpaRdSync.new
    xp_sync.update_db_peoples(person)

    assert(ExpaPerson.all.count == 1, 'DB should have only 1 register, but it has ' + ExpaPerson.all.count.to_s)
    assert(ExpaApplication.all.count > 0, 'Applications fomr user were not saved at database')
    assert(ExpaApplication.all.count == applications.count, 'DB should have ' + applications.count.to_s + ' registers , but it has ' + ExpaApplication.all.count.to_s)
  end
end
