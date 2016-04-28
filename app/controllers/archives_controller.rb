require 'dropbox_sdk'
class ArchivesController < ApplicationController


  $client = DropboxClient.new("Euuw5wSC1UAAAAAAAAAAB7srD5VuQIx79Pehcie30V_uNicxhXCqKTQJc70_dvh7")
  helper_method :get_file

  # GET /main/files
  def show
    @archives=[]
    @archives.concat(show_private)
    @archives.concat(show_public)

  end

  #POST /update
  def update (is_private = params[:is_private], tags = params[:tags], file_id = params[:file_id])

    archive = Archive.find_by_id(file_id).update(:is_private => is_private)
    delete_archive_tags file_id
    if tags != nil
      for t in tags
        archiveTag = ArchiveTag.new
        archiveTag.tag_id = t
        archiveTag.archive_id = file_id
        archiveTag.save
      end
    end

    redirect_to archives_show_path
  end

  #GET main/archives/edit/:id
  def edit(file_id = params[:id])
    tempArray= ArchiveTag.select(:tag_id).where(archive_id: file_id)
    @tags = []
    tempArray.each do |tag|
      @tags<< tag.tag_id
    end
    @file = Archive.find_by_id(file_id)
  end

  def show_private
    if @user.get_role == ExpaPerson.roles[:role_mc]
      Archive.where(is_private: true)
      # or if someone is from a LC
    else
      Archive.where(is_private: true , office_id: @user.xp_current_office.id)
    end
  end

  def show_public
    Archive.where(is_private: false)
  end
  #POST 'upload'
  def upload(upload=params[:file], is_private = params[:is_private],tags = params[:tags] )
    file = open(upload.path())
    #Save a record with the data about who uploaded the file
    record = Archive.new
    record.name = upload.original_filename
    record.office= @user.xp_current_office
    record.person = @user
    record.is_private = is_private
    record.is_deleted = false
    record.type_of_file = record.get_file_type record.name.split(".").last
    record.save
    #Saving all the selected tags for the file
    if tags != nil
      for t in tags
        archiveTag = ArchiveTag.new
        archiveTag.tag_id = t
        archiveTag.archive_id = record.id
        archiveTag.save
      end
    end
    response = $client.put_file("/#{record.id}.#{record.name.split(".").last}", file)
    redirect_to 'archives_show'
  end
  #POST 'remove'
  def remove (file_id = params[:id] )
    file = Archive.find_by_id(file_id)
    file.is_deleted= true
    file.save
    redirect_to 'archives_show'
  end

  def delete_archive_tags(file_id)

    ArchiveTag.destroy_all(:archive_id => file_id)

  end

  private :delete_archive_tags, :show_public, :show_private
end
