#There is a many to many relatioship stablished between host_people e trainee_people. 
#This is the table that is sati
class TraineeToHost < ActiveRecord::Base
  belongs_to :HostPerson, touch: true
  belongs_to :TraineePerson, touch: true
end
