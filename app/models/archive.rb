class Archive < ActiveRecord::Base
  enum type_of_file: [:pdf, :word, :excel, :ppt, :image, :sound, :video, :other]

  belongs_to :office, class_name: 'ExpaOffice'
  belongs_to :person , class_name: 'ExpaPerson'

  has_many :archive_tags, class_name: 'ArchiveTag'
  has_many :tags, through: :archive_tags, class_name: 'Tag'
end

class ArchiveTag < ActiveRecord::Base
  belongs_to :tag, class_name: 'Tag'
  belongs_to :archive, class_name: 'Archive'
end

class Tag < ActiveRecord::Base
  has_many :archive_tags, class_name: 'ArchiveTag'
  has_many :archives, through: :archive_tags, class_name: 'Archive'
end

