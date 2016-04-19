class Tag < ActiveRecord::Base

  has_many :archive_tags ,class_name: 'ArchiveTag'
  has_many :archives, through: :archive_tags, class_name: 'Archive'
end
