require 'dropbox_sdk'
require 'tempfile'
class ArchivesController < ApplicationController

  FILES_PER_PAGE = 3
  $client = DropboxClient.new(ENV["DROPBOX_TOKEN"])
  helper_method :get_file

  # GET /main/archives
  def show
    selected_tags_ids = params[:tags]
    file_permission = params[:permissao]
    search = params[:pesquisa]
    if !file_permission
      file_permission = "todos"
    end
    if search
      @archives = search_file_by_name(search).paginate(:page => params[:page], :per_page => FILES_PER_PAGE)
    elsif selected_tags_ids
      archive_ids = find_files_by_tags(selected_tags_ids)
      @archives = get_files_by_ids(file_permission, archive_ids).paginate(:page => params[:page], :per_page => FILES_PER_PAGE)
    else
      @archives = get_files(file_permission).paginate(:page => params[:page], :per_page => FILES_PER_PAGE)
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

  def get_files_by_ids permissao, archives_ids
    if permissao == "publico"
      return Archive.where("is_private = false AND id IN (?)",archives_ids)
    elsif permissao == "privado"
      if @user.get_role == ExpaPerson.roles[:role_mc]
        return Archive.where("is_private = true AND id IN (?)",archives_ids)
      elsif @user.get_role == ExpaPerson.roles[:role_eb]
        return Archive.where("is_private = true AND office_id =  ? AND id IN (?)",@user.xp_current_office.id, archives_ids)
      else
        return  Archive.where("is_deleted= false AND is_private = true AND office_id =  ? AND id IN (?)",@user.xp_current_office.id, archives_ids)
      end
    else
      if @user.get_role == ExpaPerson.roles[:role_mc]
        return Archive.where("id IN (?)",archives_ids)
        # or if someone is from a LC
      elsif @user.get_role == ExpaPerson.roles[:role_eb]
        return Archive.where("(is_private = true AND office_id =  ? AND id IN (?)) OR(is_private = false AND id IN (?)) ",@user.xp_current_office.id, archives_ids,archives_ids)
      else
        return Archive.where("(is_private = true AND is_deleted = false AND office_id =  ? AND id IN (?)) OR(is_private = false AND is_deleted = false AND id IN (?)) ",@user.xp_current_office.id, archives_ids,archives_ids)
      end
    end
  end

  def get_files permissao
    if permissao == "privado"
      if @user.get_role == ExpaPerson.roles[:role_mc]
        return Archive.where(is_private: true)
        # or if someone is from a LC
      elsif ExpaPerson.roles[:role_eb]
        return Archive.where(is_private: true , office_id: @user.xp_current_office.id)
      else
        return Archive.where(is_private: true ,:is_deleted => false, office_id: @user.xp_current_office.id)
      end
    elsif permissao == "publico"
      if @user.get_role == ExpaPerson.roles[:other]
        Archive.where(is_private: false, :is_deleted => false)
      else
        Archive.where(is_private: false)
      end
    else
      if @user.get_role == ExpaPerson.roles[:role_mc]
        return Archive.all
        # or if someone is from a LC
      elsif ExpaPerson.roles[:role_eb]
        return Archive.where("(is_private = true AND office_id =  ?) OR(is_private = false ) ",@user.xp_current_office.id)
      else
        return Archive.where("(is_private = true AND is_deleted = false AND office_id =  ? ) OR(is_private = false AND is_deleted = false ) ",@user.xp_current_office.id)
      end

    end
  end

  private :delete_archive_tags , :get_files , :get_files_by_ids, :find_files_by_tags
end
