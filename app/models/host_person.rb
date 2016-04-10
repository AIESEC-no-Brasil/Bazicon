class HostPerson < ActiveRecord::Base
	has_many :host_problem
	has_many :trainee_to_host
end
