require 'minitest/autorun'

class ExpaOpportunityTest < Minitest::Test
  def teardown
    Rake::Task['db:reset'].invoke
  end
end
