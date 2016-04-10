require 'minitest/autorun'

class ExpaCurrentPositionTest < Minitest::Test
  def teardown
    Rake::Task['db:reset'].invoke
  end
end
