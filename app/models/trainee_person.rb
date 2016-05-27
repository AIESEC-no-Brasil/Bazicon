class TraineePerson < ActiveRecord::Base
  has_many :trainee_to_hosts, dependent: :destroy
  has_many :host_people, through: :trainee_to_hosts
end
