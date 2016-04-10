require 'minitest/autorun'

class ExpaOfficeTest < Minitest::Test
  def teardown
    Rake::Task['db:reset'].invoke
  end
end
