class TraineeToHost < ActiveRecord::Base
	belongs_to :host_person
	belongs_to :trainee_person
end
