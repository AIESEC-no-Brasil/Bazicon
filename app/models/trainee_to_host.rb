class TraineeToHost < ActiveRecord::Base
  belongs_to :HostPerson
  belongs_to :TraineePerson
end
