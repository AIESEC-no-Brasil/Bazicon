class Archive < ActiveRecord::Base
  enum type_of_file: [:pdf, :word, :excel, :ppt, :image, :sound, :video, :other]

  belongs_to :office, class_name: 'ExpaOffice'
  belongs_to :person , class_name: 'ExpaPerson'

  has_many :archive_tags, class_name: 'ArchiveTag'
  has_many :tags, through: :archive_tags, class_name: 'Tag'

  def get_file_type file_type
    if file_type== 'jpg' || file_type =='jpeg'  || file_type =='png' || file_type =='jpeg' ||
        file_type =='bmp' || file_type =='gif' || file_type =='tif'
      return Archive.type_of_files[:image]
    elsif file_type == 'pdf'
      return Archive.type_of_files[:pdf]
    elsif file_type == 'doc' || file_type == 'docx'
      return Archive.type_of_files[:word]
    elsif file_type == 'ppt' || file_type == 'pptx' || file_type == 'pptm'
      return Archive.type_of_files[:ppt]
    elsif file_type == 'xls' || file_type == 'xlsx' || file_type == 'xlsm'
      return Archive.type_of_files[:excel]
    elsif file_type == 'mp3' || file_type == 'wav' || file_type == '3gp' || file_type == 'wma'||
       file_type == 'm4a'||file_type == 'flac'
      return Archive.type_of_files[:music]
    elsif file_type == 'mp4' || file_type == 'avi' || file_type == 'wmv' || file_type == 'mpg'||
        file_type == 'mpeg'||file_type == 'flv' ||file_type == 'mkv'
      return Archive.type_of_files[:video]
    end
    return Archive.type_of_files[:other]
  end
end

