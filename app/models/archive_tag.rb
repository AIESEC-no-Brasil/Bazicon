class ArchiveTag < ActiveRecord::Base

    belongs_to :tag, class_name: 'Tag'
    belongs_to :archive, class_name: 'Archive'

end
