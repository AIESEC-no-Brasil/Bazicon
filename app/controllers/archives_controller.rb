class ArchivesController < ApplicationController


    $client = DropboxClient.new("Euuw5wSC1UAAAAAAAAAAB7srD5VuQIx79Pehcie30V_uNicxhXCqKTQJc70_dvh7")

  # GET /main/files
  def show
    user_role = @user.get_role
    if user_role == ExpaPerson.roles[:role_mc]
      @office = ExpaOffice.find_by_xp_id(1606) #Brazil
    else
      @office = @user.xp_home_lc
    end
    @files = ArchiveDAO.list_from_office(@office)
    @tags = Tag.all
  end

  def show_private
    if @user.position == "mc"
      @archives = Files.where(is_private: true)
    # or if someone is from a LC
    else
      @archives.concat(Files.where(is_private: true , office_id: @user.xp_current_office.xp_id))
    end
  end

  def show_public
    @archives = Files.all
  end

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

end
