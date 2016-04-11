module ArchiveDAO
  class << self
    def all
      Archive.all
    end

    def list_from_office(office)
      if is_Brazil(office)
        all
      else
        Archive.where(office_id: office.id)
      end
    end

    def list_public_from_office(office)
      if is_Brazil(office)
        list_all_public
      else
        Archive.where(is_private: false, office_id: office.id)
      end
    end

    def list_private_from_office(office)
      if is_Brazil(office)
        list_all_private
      else
        Archive.where(is_private: true, office_id: office.id)
      end
    end

    def list_public_pdf_from_office(office)
      if is_Brazil(office)
        list_all_pdf_public
      else
        Archive.where(is_private: false, office_id: office.id, type_of_file: Archive.type_of_files[:pdf])
      end
    end

    def list_private_pdf_from_office(office)
      if is_Brazil(office)
        list_all_pdf_private
      else
        Archive.where(is_private: true, office_id: office.id, type_of_file: Archive.type_of_files[:pdf])
      end
    end

    def list_pdf_from_office(office)
      if is_Brazil(office)
        list_all_pdf
      else
        Archive.where(office_id: office.id, type_of_file: Archive.type_of_files[:pdf])
      end
    end

    def list_public_word_from_office(office)
      if is_Brazil(office)
        list_all_word_public
      else
        Archive.where(is_private: false, office_id: office.id, type_of_file: Archive.type_of_files[:word])
      end
    end

    def list_private_word_from_office(office)
      if is_Brazil(office)
        list_all_word_private
      else
        Archive.where(is_private: true, office_id: office.id, type_of_file: Archive.type_of_files[:word])
      end
    end

    def list_word_from_office(office)
      if is_Brazil(office)
        list_all_word
      else
        Archive.where(office_id: office.id, type_of_file: Archive.type_of_files[:word])
      end
    end

    def list_public_excel_from_office(office)
      if is_Brazil(office)
        list_all_excel_public
      else
        Archive.where(is_private: false, office_id: office.id, type_of_file: Archive.type_of_files[:excel])
      end
    end

    def list_private_excel_from_office(office)
      if is_Brazil(office)
        list_all_excel_private
      else
        Archive.where(is_private: true, office_id: office.id, type_of_file: Archive.type_of_files[:excel])
      end
    end

    def list_excel_from_office(office)
      if is_Brazil(office)
        list_all_excel
      else
        Archive.where(office_id: office.id, type_of_file: Archive.type_of_files[:excel])
      end
    end

    def list_public_ppt_from_office(office)
      if is_Brazil(office)
        list_all_ppt_public
      else
        Archive.where(is_private: false, office_id: office.id, type_of_file: Archive.type_of_files[:ppt])
      end
    end

    def list_private_ppt_from_office(office)
      if is_Brazil(office)
        list_all_ppt_private
      else
        Archive.where(is_private: true, office_id: office.id, type_of_file: Archive.type_of_files[:ppt])
      end
    end

    def list_ppt_from_office(office)
      if is_Brazil(office)
        list_all_ppt
      else
        Archive.where(office_id: office.id, type_of_file: Archive.type_of_files[:ppt])
      end
    end

    def list_public_image_from_office(office)
      if is_Brazil(office)
        list_all_image_public
      else
        Archive.where(is_private: false, office_id: office.id, type_of_file: Archive.type_of_files[:image])
      end
    end

    def list_private_image_from_office(office)
      if is_Brazil(office)
        list_all_image_private
      else
        Archive.where(is_private: true, office_id: office.id, type_of_file: Archive.type_of_files[:image])
      end
    end

    def list_image_from_office(office)
      if is_Brazil(office)
        list_all_image
      else
        Archive.where(office_id: office.id, type_of_file: Archive.type_of_files[:image])
      end
    end

    def list_public_sound_from_office(office)
      if is_Brazil(office)
        list_all_sound_public
      else
        Archive.where(is_private: false, office_id: office.id, type_of_file: Archive.type_of_files[:sound])
      end
    end

    def list_private_sound_from_office(office)
      if is_Brazil(office)
        list_all_sound_private
      else
        Archive.where(is_private: true, office_id: office.id, type_of_file: Archive.type_of_files[:sound])
      end
    end

    def list_sound_from_office(office)
      if is_Brazil(office)
        list_all_sound
      else
        Archive.where(office_id: office.id, type_of_file: Archive.type_of_files[:sound])
      end
    end

    def list_public_video_from_office(office)
      if is_Brazil(office)
        list_all_video_public
      else
        Archive.where(is_private: false, office_id: office.id, type_of_file: Archive.type_of_files[:video])
      end
    end

    def list_private_video_from_office(office)
      if is_Brazil(office)
        list_all_video_private
      else
        Archive.where(is_private: true, office_id: office.id, type_of_file: Archive.type_of_files[:video])
      end
    end

    def list_video_from_office(office)
      if is_Brazil(office)
        list_all_video
      else
        Archive.where(office_id: office.id, type_of_file: Archive.type_of_files[:video])
      end
    end

    def list_public_other_from_office(office)
      if is_Brazil(office)
        list_all_other_public
      else
        Archive.where(is_private: false, office_id: office.id, type_of_file: Archive.type_of_files[:other])
      end
    end

    def list_private_other_from_office(office)
      if is_Brazil(office)
        list_all_other_private
      else
        Archive.where(is_private: true, office_id: office.id, type_of_file: Archive.type_of_files[:other])
      end
    end

    def list_other_from_office(office)
      if is_Brazil(office)
        list_all_other
      else
        Archive.where(office_id: office.id, type_of_file: Archive.type_of_files[:other])
      end
    end

    def list_all_public
      Archive.where(is_private: false)
    end

    def list_all_private
      Archive.where(is_private: true)
    end

    def list_all_pdf_public
      Archive.where(type_of_file: Archive.type_of_files[:pdf], is_private: false)
    end

    def list_all_pdf_private
      Archive.where(type_of_file: Archive.type_of_files[:pdf], is_private: true)
    end

    def list_all_pdf
      Archive.where(type_of_file: Archive.type_of_files[:pdf])
    end

    def list_all_word_public
      Archive.where(type_of_file: Archive.type_of_files[:word], is_private: false)
    end

    def list_all_word_private
      Archive.where(type_of_file: Archive.type_of_files[:word], is_private: true)
    end

    def list_all_word
      Archive.where(type_of_file: Archive.type_of_files[:word])
    end

    def list_all_excel_public
      Archive.where(type_of_file: Archive.type_of_files[:excel], is_private: false)
    end

    def list_all_excel_private
      Archive.where(type_of_file: Archive.type_of_files[:excel], is_private: true)
    end

    def list_all_excel
      Archive.where(type_of_file: Archive.type_of_files[:excel])
    end

    def list_all_ppt_public
      Archive.where(type_of_file: Archive.type_of_files[:ppt], is_private: false)
    end

    def list_all_ppt_private
      Archive.where(type_of_file: Archive.type_of_files[:ppt], is_private: true)
    end

    def list_all_ppt
      Archive.where(type_of_file: Archive.type_of_files[:ppt])
    end

    def list_all_image_public
      Archive.where(type_of_file: Archive.type_of_files[:image], is_private: false)
    end

    def list_all_image_private
      Archive.where(type_of_file: Archive.type_of_files[:image], is_private: true)
    end

    def list_all_image
      Archive.where(type_of_file: Archive.type_of_files[:image])
    end

    def list_all_sound_public
      Archive.where(type_of_file: Archive.type_of_files[:sound], is_private: false)
    end

    def list_all_sound_private
      Archive.where(type_of_file: Archive.type_of_files[:sound], is_private: true)
    end

    def list_all_sound
      Archive.where(type_of_file: Archive.type_of_files[:sound])
    end

    def list_all_video_public
      Archive.where(type_of_file: Archive.type_of_files[:video], is_private: false)
    end

    def list_all_video_private
      Archive.where(type_of_file: Archive.type_of_files[:video], is_private: true)
    end

    def list_all_video
      Archive.where(type_of_file: Archive.type_of_files[:video])
    end

    def list_all_other_public
      Archive.where(type_of_file: Archive.type_of_files[:other], is_private: false)
    end

    def list_all_other_private
      Archive.where(type_of_file: Archive.type_of_files[:other], is_private: true)
    end

    def list_all_other
      Archive.where(type_of_file: Archive.type_of_files[:other])
    end

    private

    def is_Brazil(office)
      true if office.xp_id == 1606
    end
  end
end