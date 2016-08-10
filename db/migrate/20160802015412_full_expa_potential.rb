class FullExpaPotential < ActiveRecord::Migration[5.0]
  def up
  	enable_extension 'hstore' unless extension_enabled?('hstore')
    add_column :expa_people, :xp_first_name, :string
    add_column :expa_people, :xp_address, :hstore, default: {}, null:false
  	add_column :expa_people, :xp_contact, :hstore, default: {}, null:false
  	add_column :expa_people, :xp_costumer_profile, :json, default: {}, null:false
  	add_column :expa_people, :xp_academic_xps, :json, default: {}, null:false
  	add_column :expa_people, :xp_professional_xps, :json, default: {}, null:false
  	remove_column :expa_people, :xp_missing_profile_fields
  	add_column :expa_people, :xp_missing_profile_fields, :json, default: {}, null:false
  	add_column :expa_people, :xp_programmes, :json, default: {}, null:false

  	add_column :expa_applications, :xp_paid_at, :timestamp
  	add_column :expa_applications, :xp_meta, :json, default: {}, null:false

    add_column :expa_opportunities, :xp_current_status, :string
    remove_column :expa_opportunities, :xp_programmes
    add_column :expa_opportunities, :xp_programmes, :json, default: {}, null:false
    add_column :expa_opportunities, :xp_views, :integer
    add_column :expa_opportunities, :xp_duration_min, :integer
    add_column :expa_opportunities, :xp_duration_max, :integer
    add_column :expa_opportunities, :xp_cover_photo_urls, :string
    add_column :expa_opportunities, :xp_created_at, :timestamp
    add_column :expa_opportunities, :xp_updated_at, :timestamp
    add_column :expa_opportunities, :xp_is_gep, :boolean
    add_column :expa_opportunities, :xp_is_ge, :boolean
    add_column :expa_opportunities, :xp_favorites, :integer
    add_column :expa_opportunities, :xp_applied_to, :boolean
    add_column :expa_opportunities, :xp_host_lc_id, :integer
    add_column :expa_opportunities, :xp_home_lc_id, :integer
    add_column :expa_opportunities, :xp_project, :integer
    add_column :expa_opportunities, :xp_openings, :integer
    add_column :expa_opportunities, :xp_available_openings, :integer
    add_column :expa_opportunities, :xp_skills, :json, default: {}, null:false
    add_column :expa_opportunities, :xp_backgrounds, :json, default: {}, null:false
    add_column :expa_opportunities, :xp_languages, :json, default: {}, null:false
    add_column :expa_opportunities, :xp_issues, :json, default: {}, null:false
    add_column :expa_opportunities, :xp_work_fields, :json, default: {}, null:false
    add_column :expa_opportunities, :xp_study_levels, :json, default: {}, null:false
    add_column :expa_opportunities, :xp_prefered_locations, :json, default: {}, null:false
    add_column :expa_opportunities, :xp_role_info, :json, default: {}, null:false
    add_column :expa_opportunities, :xp_logistic_info, :json, default: {}, null:false
    add_column :expa_opportunities, :xp_legal_info, :json, default: {}, null:false
    add_column :expa_opportunities, :xp_specifics_info, :json, default: {}, null:false
    add_column :expa_opportunities, :xp_department, :integer
    add_column :expa_opportunities, :xp_tm_details, :json, default: {}, null:false
    add_column :expa_opportunities, :xp_nps_score, :integer
  end
end
