require 'minitest/autorun'

class ExpaOpportunityTest < Minitest::Test
  def teardown
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end
end
