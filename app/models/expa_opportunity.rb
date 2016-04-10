class ExpaOpportunity < ActiveRecord::Base

  belongs_to :xp_office, class_name: 'ExpaOffice'

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

    self.xp_id = data.id unless data.id.nil?
    self.xp_title = data.title unless data.title.nil?
    self.xp_url = data.url unless data.url.nil?
    self.xp_status = data.status unless data.status.nil?
    self.xp_location = data.location unless data.location.nil?
    self.xp_programmes = data.programmes.to_json.to_s unless data.programmes.nil?
    self.xp_office = office unless office.nil?
    self.xp_application_count = data.application_count unless data.application_count.nil?
    self.xp_earliest_start_date = data.earliest_start_date unless data.earliest_start_date.nil?
    self.xp_latest_end_date = data.latest_end_date unless data.latest_end_date.nil?
    self.xp_applications_close_date = data.applications_close_date unless data.applications_close_date.nil?
    self.xp_profile_photo_url = data.profile_photo_url unless data.profile_photo_url.nil?
  end
end
