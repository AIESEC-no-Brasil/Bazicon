require 'test_helper'

class HostProblemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def test_create
  	problem = HostProblem.new
  	problem.reported_date = "2016-04-10 12:38:43"
  	problem.problem_description = "Texto de test"
  	assert person.save, "Não Salvou"
  end
  def test_delete
  	problem = HostProblem.new
  	problem.reported_date = "2016-04-10 12:38:43"
  	problem.problem_description = "Texto de test"
  	person.save
  	assert person.destroy, "Não Deletou"
  end

end
