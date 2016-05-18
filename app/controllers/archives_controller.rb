require 'dropbox_sdk'

class ArchivesController < ApplicationController

  FILES_PER_PAGE = 12
  $client = DropboxClient.new(ENV["DROPBOX_TOKEN"])
  helper_method :get_file

  # GET /main/archives
  def show
    selected_tags_ids = params[:tags]
    show_private = params[:show_private]
    show_public = params[:show_public]
    search = params[:pesquisa]
    page = params[:page]
    if search
      @archives = search_file_by_name(search).paginate(page: params[:page], per_page: FILES_PER_PAGE)
    elsif selected_tags_ids
      if selected_tags_ids.length == 0
        selected_tags_ids = get_all_tags_ids
      end
      archive_ids = find_files_by_tags(selected_tags_ids)
      @archives = get_files_by_ids(show_private,show_public,archive_ids).paginate(:page => params[:page], :per_page => FILES_PER_PAGE)
    else
      @archives = get_files(show_private,show_public).paginate(:page => params[:page], :per_page => FILES_PER_PAGE)
    end

  end

  def download(file_id = params[:id])

    file = Archive.find_by(id: file_id)
    downloaded_file= $client.get_file("/#{file.id}#{file.archive_extension}")
    temp_file = Tempfile.new('tmp_file')
    open(temp_file,"wb") {|f| f.puts downloaded_file}
    temp_file.close
    send_file temp_file.path, :filename =>  "#{file.name}#{file.archive_extension}"

  end


  def restore_archive
    file_id = params[:id]
    file = Archive.find_by(id:file_id)
    file.is_deleted=false
    file.save
    redirect_to archives_show_path
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

  #POST 'upload'
  def upload(upload=params[:file], is_private = params[:is_private],tags = params[:tags] )
    file = open(upload.path())
    #Save a record with the data about who uploaded the file
    file_extension = File.extname(upload.original_filename)
    record = Archive.new
    record.name = File.basename(upload.original_filename,file_extension)
    record.office= @user.xp_current_office
    record.person = @user
    record.is_private = is_private
    record.is_deleted = false
    record.archive_extension= file_extension
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
    response = $client.put_file("/#{record.id}#{record.archive_extension}", file)
    if response['thumb_exists'] == true
      thumbnail = $client.thumbnail("/#{record.id}#{record.archive_extension}", 'l')
      open("app/assets/images/thumbnails/thumb_#{record.id.to_s}.jpg","wb") {|f| f.puts thumbnail}
    end
    redirect_to archives_show_path
  end
  #POST 'remove'
  def remove (file_id = params[:id] )
    file = Archive.find_by_id(file_id)
    file.is_deleted= true
    file.save
    redirect_to archives_show_path
  end

  def delete_archive_tags(file_id)

    ArchiveTag.destroy_all(:archive_id => file_id)

  end
  ##
  # Get ids of files related do the tags passed as parameters
  def find_files_by_tags selected_tags_ids

    archive_ids = []
    archive_ids_sql = Archive.select("archives.id as file_id").joins(:archive_tags).where("archive_tags.tag_id IN (?)", selected_tags_ids.split(",").map(&:to_i))
    for archive in archive_ids_sql
      archive_ids << archive.file_id
    end
    return archive_ids

  end

  ##
  # Get ids of files related do the tags passed as parameters
  def search_file_by_name (search)

    if @user.get_role == ExpaPerson.roles[:role_mc]
      return Archive.where("name ILIKE ?","%#{search}%")
      # or if someone is from a LC
    elsif @user.get_role == ExpaPerson.roles[:role_eb]
      return Archive.where("(is_private = true AND office_id =  ? AND name ILIKE ?) OR (is_private = false  AND name ILIKE ? )",@user.xp_current_office.id, "%#{search}%", "%#{search}%")
    else
      return Archive.where("(is_deleted = false is_private = true AND office_id =  ? AND name ILIKE ?) OR (is_deleted = false AND is_private = false  AND name ILIKE ?)",@user.xp_current_office.id, "%#{search}%", "%#{search}%")
    end

  end

  def get_files_by_ids show_private,show_public, archives_ids

    if show_private && show_public
      if @user.get_role == ExpaPerson.roles[:role_mc]
        return Archive.where("id IN (?)", archives_ids)
      else
        return  Archive.where("(is_private = false OR(is_private=true AND office_id =  ?)) AND id IN (?) AND is_deleted=false",@user.xp_current_office.id, archives_ids)
      end
    elsif show_private
      if @user.get_role == ExpaPerson.roles[:role_mc]
        return Archive.where("is_private = true AND id IN (?)", archives_ids)
      else
        return Archive.where("(is_private=true  AND office_id =  ? AND is_deleted=false ) AND id IN (?)",@user.xp_current_office.id, archives_ids)
      end
    elsif show_public
      if @user.get_role == ExpaPerson.roles[:role_mc]
        return Archive.where("is_private = false AND id IN (?)", archives_ids)
      else
        return Archive.where("is_private = false AND is_deleted =false AND id IN (?)", archives_ids)
      end
    else
      if @user.get_role == ExpaPerson.roles[:role_mc]
        return Archive.where("id IN (?)", archives_ids)
      else
        return  Archive.where("(is_private = false OR(is_private=true AND office_id =  ?)) AND id IN (?) AND is_deleted=false",@user.xp_current_office.id, archives_ids)
      end
    end
  end



  def get_files show_private,show_public

    if show_private && show_public
      if @user.get_role == ExpaPerson.roles[:role_mc]
        return Archive.all
      else
        return Archive.where("(is_private = false OR(is_private=true  AND office_id =  ?)) AND is_deleted = false",@user.xp_current_office.id)
      end
    elsif show_private
      if @user.get_role == ExpaPerson.roles[:role_mc]
        return Archive.where(" is_private = true" )
      else
        return Archive.where(" (is_private=true  AND office_id =  ? AND is_deleted=false )",@user.xp_current_office.id)
      end
    elsif show_public
      if @user.get_role == ExpaPerson.roles[:role_mc]
        return Archive.where(" is_private = false" )
      else
        return Archive.where(" is_private = false and is_deleted=false" )
      end

    else
      if @user.get_role == ExpaPerson.roles[:role_mc]
        return Archive.all
      else
        return Archive.where("(is_private = false OR(is_private=true  AND office_id =  ?)) AND is_deleted = false",@user.xp_current_office.id)
      end
    end
  end

  def get_all_tags_ids
    selected_tags_ids = ""
    tags_ids_query = Tag.all
    i = 0
    for tag in tags_ids_query
      i = i+1
      if i == tags_ids_query.length
        selected_tags_ids << "#{tag.id}"
      else
        selected_tags_ids << "#{tag.id},"
      end
    end
    return selected_tags_ids
  end

  def get_all_tags_ids_array
    tags_ids_query = Tag.all
    selected_tags_ids = []
    for tag in tags_ids_query
      selected_tags_ids << tag.id
    end
    return selected_tags_ids

  end

  private :delete_archive_tags , :get_files , :get_files_by_ids, :find_files_by_tags
end
