class CreateExpaPeople < ActiveRecord::Migration
  def change
    create_table :expa_people do |t|
      t.column :xp_id, :integer #done
      t.column :xp_email, :string #done
      t.column :xp_url, :string #done
      t.column :xp_birthday_date, :date #done
      t.column :xp_full_name, :string #done
      t.column :xp_last_name, :string #done
      t.column :xp_profile_photo_url, :string #done
      t.column :xp_home_lc_id, :integer #done #foreigner_key (expa_office)
      t.column :xp_home_mc_id, :integer #done #foreigner_key (expa_office)
      t.column :xp_status, :integer #done #ENUM (from string to enum)
      t.column :xp_interviewed, :boolean, default: false #done
      t.column :xp_phone, :string #done
      t.column :xp_location, :string #done
      t.column :xp_created_at, :timestamp #done
      t.column :xp_updated_at, :timestamp #done
      t.column :xp_middles_names, :string #done
      t.column :xp_introduction, :string
      t.column :xp_aiesec_email, :string
      t.column :xp_payment, :boolean, default: false #done
      #t.column :xp_programmes, :string #TODO: struct
      t.column :xp_views, :integer #done
      t.column :xp_favourites_count, :integer #done
      t.column :xp_contacted_at, :timestamp #done
      t.column :xp_contacted_by, :string
      t.column :xp_gender, :integer #enum (from string to enum)
      t.column :xp_address_info, :text
      t.column :xp_contact_info, :string
      t.column :xp_current_office_id, :integer #foreigner_key (office)
      t.column :xp_cv_info, :string #json #done
      t.column :xp_profile_photos_urls, :string
      t.column :xp_cover_photo_urls, :string
      #t.column :xp_teams, :string #TODO: struct
      #t.column :xp_positions, :string #TODO: struct
      t.column :xp_profile, :string
      t.column :xp_academic_experience, :string #TODO: struct
      #t.column :xp_professional_experience, :string #TODO: struct
      #t.column :xp_managers, :string #TODO: struct
      t.column :xp_missing_profile_fields, :string
      t.column :xp_nps_score, :integer #done
      #t.column :xp_current_experience, :string #TODO: struct
      t.column :xp_permissions, :string #json #done

      t.column :entity_exchange_lc_id, :integer #done #foreigner_key (office)
      t.column :interested_program, :integer #enum
      t.column :interested_sub_product, :integer #enum
      t.column :how_got_to_know_aiesec, :integer #enum

      t.column :customized_fields, :text #json
      t.column :control_podio, :text #json

      t.timestamps null: false
    end
  end
end
