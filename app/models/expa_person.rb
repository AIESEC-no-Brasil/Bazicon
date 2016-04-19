class ExpaPerson < ActiveRecord::Base
  enum xp_status: [:open, :in_progress, :matched, :realized, :completed, :other]
  enum xp_gender: [:male, :female, :prefer_not_to_answer]
  enum interested_program: [:global_volunteer, :global_talents]
  enum interested_sub_product: [:global_volunteer_arab, :global_volunteer_east_europe, :global_volunteer_africa, :global_volunteer_asia, :global_volunteer_latam, :global_talents_start_up, :global_talents_educacional, :global_talents_IT, :global_talents_management]
  enum how_got_to_know_aiesec: [:facebook, :friends_family, :google, :posters, :tv, :twitter, :academic_center, :junior_company, :flyer, :disclouse_in_classroom, :global_village, :stand, :instagram, :indication_campaign, :youth_speak, :how_got_to_know_aiesec_other]
  enum role: [:role_mc, :role_eb, :role_other]

  belongs_to :xp_home_lc, class_name: 'ExpaOffice'
  belongs_to :xp_home_mc, class_name: 'ExpaOffice'
  belongs_to :xp_current_office, class_name: 'ExpaOffice'
  belongs_to :entity_exchange_lc, class_name: 'ExpaOffice'
  belongs_to :xp_current_position, class_name: 'ExpaCurrentPosition'

  has_many :xp_applications, class_name: 'ExpaApplication', foreign_key: 'xp_person_id'

  has_many :uploaded_files, class_name: 'Archive', foreign_key: 'person'
  has_many :responsibled_hosts, class_name: 'Host', foreign_key: 'tmp_responsible'
  has_many :meeted_hosts, class_name: 'Host', foreign_key: 'tmp_who_realized_meeting'

  has_many :comments_that_i_own, class_name: 'ExpaPersonComment', foreign_key: 'owner_id'
  has_many :received_comments, through: :comments_that_i_own
  has_many :comments_that_i_made, class_name: 'ExpaPersonComment', foreign_key: 'person_id'
  has_many :made_comments, through: :comments_that_i_made

  has_and_belongs_to_many :ep_managers, class_name: 'ExpaPerson', :join_table => 'expa_person_ep_managers', :foreign_key => 'person_id', :association_foreign_key => 'manager_id'

  validates :xp_id,
            uniqueness: true,
            presence: false
  validates :xp_email,
            uniqueness: true,
            presence: false

  after_validation :downcase_email

  def update_from_expa(data)
    unless data.home_lc.nil?
      home_lc = ExpaOffice.find_by_xp_id(data.home_lc.id)
      if home_lc.nil?
        home_lc = ExpaOffice.new
        home_lc.update_from_expa(data.home_lc)
        home_lc.save
      end
    end
    unless data.home_mc.nil?
      home_mc = ExpaOffice.find_by_xp_id(data.home_mc.id)
      if home_mc.nil?
        home_mc = ExpaOffice.new
        home_mc.update_from_expa(data.home_mc)
        home_mc.save
      end
    end
    unless data.current_office.nil?
      current_office = ExpaOffice.find_by_xp_id(data.current_office.id)
      if current_office.nil?
        current_office = ExpaOffice.new
        current_office.update_from_expa(data.current_office)
        current_office.save
      end
    end
    unless data.current_position.nil?
      current_position = ExpaCurrentPosition.find_by_xp_id(data.current_position.id)
      if current_position.nil?
        current_position = ExpaCurrentPosition.new
        current_position.update_from_expa(data.current_position)
        current_position.save
      end
    end


    self.xp_id = data.id unless data.id.nil?
    self.xp_email = data.email unless data.email.nil?
    self.xp_url = data.url.to_s unless data.url.nil?
    self.xp_birthday_date = data.birthday_date unless data.birthday_date.nil?
    self.xp_full_name = data.full_name unless data.full_name.nil?
    self.xp_last_name = data.last_name unless data.last_name.nil?
    self.xp_profile_photo_url = data.profile_photo_url.to_s unless data.profile_photo_url.nil?
    self.xp_home_lc = home_lc unless home_lc.nil?
    self.xp_home_mc = home_mc unless home_mc.nil?
    self.xp_status = data.status.to_s.downcase.gsub(' ','_') unless data.status.nil?
    self.xp_interviewed = data.interviewed unless data.interviewed.nil?
    self.xp_phone = data.phone unless data.phone.nil?
    self.xp_location = data.location unless data.location.nil?
    self.xp_created_at = data.created_at unless data.created_at.nil?
    self.xp_updated_at = data.updated_at unless data.updated_at.nil?
    self.xp_middles_names = data.middles_names unless data.middles_names.nil?
    self.xp_introduction = data.introduction unless data.introduction.nil?
    self.xp_aiesec_email = data.aiesec_email unless data.aiesec_email.nil?
    self.xp_payment = data.payment unless data.payment.nil?
    #self.xp_programmes = data.programmes #TODO: struct
    self.xp_views = data.views unless data.views.nil?
    self.xp_favourites_count = data.favourites_count.to_i unless data.favourites_count.nil?
    self.xp_contacted_at = data.contacted_at unless data.contacted_at.nil?
    self.xp_contacted_by = data.contacted_by unless data.contacted_by.nil?
    self.xp_gender = data.gender.downcase.gsub(' ','_') unless data.gender.nil?
    self.xp_address_info = data.address_info unless data.address_info.nil?
    self.xp_contact_info = data.contact_info unless data.contact_info.nil?
    self.xp_current_office = current_office unless current_office.nil?
    self.xp_cv_info = data.cv_info unless data.cv_info.nil?
    self.xp_profile_photos_urls = data.profile_photos_urls unless data.profile_photos_urls.nil?
    self.xp_cover_photo_urls = data.cover_photo_urls unless data.cover_photo_urls.nil?
    #self.xp_teams = data.teams #TODO: struct
    #self.xp_positions = data.positions #TODO: struct
    self.xp_profile = data.profile unless data.profile.nil?
    #self.xp_academic_experience = data.academic_experience #TODO: struct
    #self.xp_professional_experience = data.professional_experience #TODO: struct
    #self.xp_managers = data.managers #TODO: struct
    self.xp_missing_profile_fields = data.missing_profile_fields unless data.missing_profile_fields.nil?
    self.xp_nps_score = data.nps_score.to_i unless data.nps_score.nil?
    #self.xp_current_experience = data.current_experience #TODO: struct
    self.xp_permissions = data.permissions unless data.permissions.nil?
    self.xp_current_position = current_position unless current_position.nil?
  end

  def get_role
    if self.xp_current_office == self.xp_home_mc
      ExpaPerson.roles[:role_mc]
    elsif !self.xp_current_position.nil? && self.xp_current_position.xp_team.xp_team_type == 'eb'
      ExpaPerson.roles[:role_eb]
    else
      ExpaPerson.roles[:role_other]
    end
  end

  #TODO Unit Test
  def get_applications
    if self.xp_status == 'open'
      return nil
    else
      applications = ExpaApplication.find_by_xp_person_id(self.xp_id)
      if applications.blank?
        applications = EXPA::Peoples.get_applications(self.xp_id)
        xp_sync = ExpaRdSync.new
        applications.each do |xp_application|
          xp_sync.update_db_applications(xp_application)
        end
        applications = ExpaApplication.find_by_xp_person_id(self.xp_id)
      end
      applications
    end
  end

  def list_programs
    if self.xp_status == 'open'
      return []
    else
      programs = {}
      list_programmes = []
      applications = self.get_applications
      apps = []
      unless applications.is_a?(Array)
        apps << applications
      end
      applications = apps
      applications.each do |app|
        app_programmes = JSON.parse(app.xp_opportunity.xp_programmes)
        for program in app_programmes
          list_programmes << program['short_name'] unless program['short_name'].nil?
        end
      end
      list_programmes.each do |program|
        programs[program] = nil
      end
      programs.keys
    end
  end

  def get_university_string
    (JSON.parse(self.customized_fields).include?('universidade') ? JSON.parse(self.customized_fields)['universidade'] : '') unless self.customized_fields.nil?
  end

  def get_sub_product_string
    case ExpaPerson.interested_sub_products[self.interested_sub_product]
      when 0 then 'Mundo Árabe'
      when 1 then 'Leste Europeu'
      when 2 then 'África'
      when 3 then 'Ásia'
      when 4 then 'Latam'
      when 5 then 'Start-up'
      when 6 then 'Educacional'
      when 7 then 'Tecnologia da Informação'
      when 8 then 'Gestão'
    end
  end


  private

  def downcase_email
    self.xp_email.downcase unless self.xp_email.nil?
    self.xp_aiesec_email.downcase unless self.xp_aiesec_email.nil?
  end

end

class ExpaPersonComment < ActiveRecord::Base
  belongs_to :person, class_name: 'ExpaPerson'
  belongs_to :owner, class_name: 'ExpaPerson'
end