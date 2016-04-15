require 'minitest/autorun'

class ExpaPersonTest < Minitest::Test
  def setup
    if EXPA.client.nil?
      xp = EXPA.setup()
      xp.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])
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
  end

  def populate_db

  end

  def test_get_applications

  end

  def test_what_programs
    params = {'per_page' => 1, 'filters[status]' => 'completed'}
    people = EXPA::People.list_by_param(params).first
    xp_sync = ExpaRdSync.new
    xp_sync.update_db_peoples(people)
    person = ExpaPerson.all.first

    assert(!person.list_programs.blank?, 'No programme was returned. Function is not working or database is not being well populated')
  end

  
end
