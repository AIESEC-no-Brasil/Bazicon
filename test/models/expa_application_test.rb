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
    Rake::Task['db:reset'].invoke
  end
end
