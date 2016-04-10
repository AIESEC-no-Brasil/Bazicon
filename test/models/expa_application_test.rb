require 'minitest/autorun'

class ExpaApplicationTest < Minitest::Test
  def setup
    if EXPA.client.nil?
      xp = EXPA.setup()
      xp.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])
    end
    teardown
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
  end
end
