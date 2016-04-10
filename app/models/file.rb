class File < ActiveRecord::Base
  enum type: [:pdf, :word, :excel, :ppt, :image, :sound, :video, :other]

  belongs_to :office_id, class_name: 'ExpaOffice'
  belongs_to :person_id , class_name: 'ExpaPerson'

  has_many :file_tags, class_name: 'FileTag'
  has_many :tags, through: :file_tags, class_name: 'Tag'
end

class FileTag < ActiveRecord::Base
  belongs_to :tag_id, class_name: 'Tag'
  belongs_to :archive_id, class_name: 'File'
end

class Tag < ActiveRecord::Base
  has_many :file_tags, class_name: 'FileTag'
  has_many :files, through: :file_tags, class_name: 'File'
end

module Files
  class << self

  end
end

