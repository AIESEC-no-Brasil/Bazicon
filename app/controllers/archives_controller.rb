require 'dropbox_sdk'
class ArchivesController < ApplicationController

  FILES_PER_PAGE = 2
  $client = DropboxClient.new("Euuw5wSC1UAAAAAAAAAAB7srD5VuQIx79Pehcie30V_uNicxhXCqKTQJc70_dvh7")
  helper_method :get_file

  # GET /main/files
  def show
    tags_ids= params[:tags]
    if tags_ids.nil?
      @archives=[]
      permissao=params[:permissao]
      if permissao.nil?
        permissao = "todos"
      end
      @archives.concat(retrieve_files(permissao))
      @archives
    else
      archive_ids = []
      archive_ids_sql = Archive.select("archives.id as file_id").joins(:archive_tags).where("archive_tags.tag_id IN (?)", tags_ids.split(",").map(&:to_i))
      for archive in archive_ids_sql
        archive_ids << archive.file_id
      end
      @archives = Archive.where("id IN (?)",archive_ids).paginate(:page => params[:page], :per_page => FILES_PER_PAGE)
    end
  end

  def retrieve_files(permissao)
    if permissao = "privado"
      if @user.get_role == ExpaPerson.roles[:role_mc]
        return Archive.where(is_private: true)
        # or if someone is from a LC
      else
       return Archive.where(is_private: true , office_id: @user.xp_current_office.id)
      end
    elsif permissao ="publico"
      Archive.where(is_private: false)
    else
      if @user.get_role == ExpaPerson.roles[:role_mc]
        return Archive.all
        # or if someone is from a LC
      else
        archives = Archive.where(is_private: true , office_id: @user.xp_current_office.id)
        archives.concat(Archive.where(is_private: false))
        return archives
      end

    end
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
