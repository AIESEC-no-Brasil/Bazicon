require 'minitest/autorun'

class ExpaCurrentPositionTest < Minitest::Test
  def teardown
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end
end
