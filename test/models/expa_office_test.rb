require 'minitest/autorun'

class ExpaOfficeTest < Minitest::Test
  def teardown
    ActiveRecord::Base.subclasses.each(&:delete_all)
  end
end
