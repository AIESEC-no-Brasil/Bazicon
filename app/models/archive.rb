class Archive < ActiveRecord::Base
  enum type_of_file: [:pdf, :word, :excel, :ppt, :image, :sound, :video, :other]

  belongs_to :office, class_name: 'ExpaOffice'
  belongs_to :person , class_name: 'ExpaPerson'

  has_many :archive_tags, class_name: 'ArchiveTag'
  has_many :tags, through: :archive_tags, class_name: 'Tag'

  def get_file_type
    if self.archive_extension== '.jpg' || self.archive_extension =='.jpeg'  || self.archive_extension =='.png' || self.archive_extension =='.jpeg' ||
        self.archive_extension =='.bmp' || self.archive_extension =='.gif' || self.archive_extension =='.tif'
      return Archive.type_of_files[:image]
    elsif self.archive_extension == '.pdf'
      return Archive.type_of_files[:pdf]
    elsif self.archive_extension == '.doc' || self.archive_extension == '.docx'
      return Archive.type_of_files[:word]
    elsif self.archive_extension == '.ppt' || self.archive_extension == '.pptx' || self.archive_extension == '.pptm'
      return Archive.type_of_files[:ppt]
    elsif self.archive_extension == '.xls' || self.archive_extension == '.xlsx' || self.archive_extension == '.xlsm'
      return Archive.type_of_files[:excel]
    elsif self.archive_extension == '.mp3' || self.archive_extension == '.wav' || self.archive_extension == '.3gp' || self.archive_extension == '.wma'||
       self.archive_extension == '.m4a'||self.archive_extension == '.flac'
      return Archive.type_of_files[:music]
    elsif self.archive_extension == '.mp4' || self.archive_extension == '.avi' || self.archive_extension == '.wmv' || self.archive_extension == '.mpg'||
        self.archive_extension == '.mpeg'||self.archive_extension == '.flv' ||self.archive_extension == '.mkv'
      return Archive.type_of_files[:video]
    end
    return Archive.type_of_files[:other]
  end




end


