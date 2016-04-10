require 'minitest/autorun'

class ExpaTeamTest < Minitest::Test
  def teardown
    Rake::Task['db:reset'].invoke
  end
end
