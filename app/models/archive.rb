class Archive < ActiveRecord::Base

  belongs_to :office_id, class_name: 'ExpaOffice'
  belongs_to :person_id , class_name: 'ExpaPerson'

end
