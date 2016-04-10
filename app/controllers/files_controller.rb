class FilesController < ApplicationController


  # GET /main/files
  def show

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

  def upload(upload=params[:file], is_private= params[:show], committeeId = params[:committeeId])
    unless upload == nil || Files.find_by_name("#{upload.original_filename}")
      file = open(upload.path())
      #Save a record with the data about who uploaded the file
      record = Files.new
      record.name = upload.original_filename
      if !committeeId
        committeeId = session[:committee]
      end
      if !is_private
        is_private = false
      end
      record.office_id = committeeId
      record.user_id = session[:user_id]
      record.is_private = is_private
      record.is_deleted = false
      record.save
      #Saving all the selected tags for the file
      if $tags_id != nil
        for t in $tags_id
          archiveTag = ArchiveTag.new
          archiveTag.tag_id = t
          archiveTag.archive_id = record.id
          archiveTag.save
        end
      end
      response = $client.put_file("/#{record.id}.#{record.name.split(".").last}", file)
    end
    redirect_to authentication_files_path
  end

end
