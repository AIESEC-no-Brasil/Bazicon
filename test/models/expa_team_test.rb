require 'minitest/autorun'

class ExpaTeamTest < Minitest::Test
  def teardown
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end
end
