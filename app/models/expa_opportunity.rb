class ExpaOpportunity < ActiveRecord::Base

  belongs_to :xp_office, class_name: 'ExpaOffice'
  belongs_to :xp_home_lc, class_name: 'ExpaOffice'
  belongs_to :xp_host_lc, class_name: 'ExpaOffice'
  has_many :xp_application, class_name: 'ExpaApplication', foreign_key: 'xp_opportunity_id', primary_key: 'xp_id'

  validates :xp_id,
            uniqueness: true,
            presence: false

  def update_from_expa(data)
    unless data.office.nil?
      office = ExpaOffice.find_by_xp_id(data.office.id)
      if office.nil?
        office = ExpaOffice.new
        office.update_from_expa(data.office)
        office.save
      end
    end
    unless data.host_lc.nil?
      host_lc = ExpaOffice.find_by_xp_id(data.host_lc.id)
      if host_lc.nil?
        host_lc = ExpaOffice.new
        host_lc.update_from_expa(data.host_lc)
        host_lc.save
      end
    end
    unless data.home_lc.nil?
      home_lc = ExpaOffice.find_by_xp_id(data.home_lc.id)
      if home_lc.nil?
        home_lc = ExpaOffice.new
        home_lc.update_from_expa(data.home_lc)
        home_lc.save
      end
    end
    self.xp_id = data.id unless data.id.nil?
    self.xp_title = data.title unless data.title.nil?
    self.xp_url = data.url unless data.url.nil?
    self.xp_status = data.status unless data.status.nil?
    self.xp_current_status = data.current_status unless data.current_status.nil?
    self.xp_location = data.location unless data.location.nil?
    self.xp_programmes = (data.programmes.nil? || data.programmes.to_s.length <= 2) ? {} : data.programmes
    self.xp_application_count = data.application_count unless data.application_count.nil?
    self.xp_views = data.views unless data.views.nil?
    self.xp_duration_min = data.duration_min unless data.duration_min.nil?
    self.xp_duration_max = data.duration_max unless data.duration_max.nil?
    self.xp_applications_close_date = data.applications_close_date unless data.applications_close_date.nil?
    self.xp_earliest_start_date = data.earliest_start_date unless data.earliest_start_date.nil?
    self.xp_latest_end_date = data.latest_end_date unless data.latest_end_date.nil?
    self.xp_profile_photo_url = data.profile_photo_url unless data.profile_photo_url.nil?
    self.xp_cover_photo_urls = data.cover_photo_urls unless data.cover_photo_urls.nil?
    self.xp_created_at = data.created_at unless data.created_at.nil?
    self.xp_updated_at = data.updated_at unless data.updated_at.nil?
    self.xp_office = office unless office.nil?
    self.xp_is_gep = data.is_gep unless data.is_gep.nil?
    self.xp_is_ge = data.is_ge unless data.is_ge.nil?
    self.xp_favorites = data.favorites unless data.favorites.nil?
    self.xp_applied_to = data.applied_to unless data.applied_to.nil?
    self.xp_host_lc = host_lc unless host_lc.nil?
    self.xp_home_lc = home_lc unless home_lc.nil?
    self.xp_project = data.project unless data.project.nil?
    self.xp_openings = data.openings unless data.openings.nil?
    self.xp_available_openings = data.available_openings unless data.available_openings.nil?
    self.xp_skills = (data.skills.nil? || data.skills.to_s.length <= 2) ? {} : data.skills
    self.xp_backgrounds = (data.backgrounds.nil? || data.backgrounds.to_s.length <= 2) ? {} : data.backgrounds
    self.xp_languages = (data.languages.nil? || data.languages.to_s.length <= 2) ? {} : data.languages
    self.xp_issues = (data.issues.nil? || data.issues.to_s.length <= 2) ? {} : data.issues
    self.xp_work_fields = (data.work_fields.nil? || data.work_fields.to_s.length <= 2) ? {} : data.work_fields
    self.xp_study_levels = (data.study_levels.nil? || data.study_levels.to_s.length <= 2) ? {} : data.study_levels
    self.xp_prefered_locations = (data.prefered_locations.nil? || data..to_s.length <= 2) ? {} : data.prefered_locations
    self.xp_role_info = (data.role_info.nil? || data.role_info.to_s.length <= 2) ? {} : data.role_info
    self.xp_logistic_info = (data.logistic_info.nil? || data.logistic_info.to_s.length <= 2) ? {} : data.logistic_info
    self.xp_legal_info = (data.legal_info.nil? || data.legal_info.to_s.length <= 2) ? {} : data.legal_info
    self.xp_specifics_info = (data.specifics_info.nil? || data.specifics_info.to_s.length <= 2) ? {} : data.specifics_info
    self.xp_department = data.department unless data.department.nil?
    self.xp_tm_details = (data.tm_details.nil? || data.tm_details.to_s.length <= 2) ? {} : data.tm_details
    self.xp_nps_score = data.nps_score unless data.nps_score.nil?
  end
end
