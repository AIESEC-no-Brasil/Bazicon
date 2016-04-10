class ExpaCurrentPosition < ActiveRecord::Base

  belongs_to :xp_team_id, class_name: 'ExpaTeam'

  validates :xp_id,
            uniqueness: true,
            presence: false

  def update_from_expa(data)
    unless data.team.nil?
      team = ExpaTeam.find_by_xp_id(data.team.id)
      if current_office.nil?
        team = ExpaTeam.new
        team.update_from_expa(data.team)
        team.save
      end
    end

    self.xp_id = data.id unless data.id.nil?
    self.xp_position_name = data.position_name unless data.position_name.nil?
    self.xp_position_short_name = data.position_short_name unless data.position_short_name.nil?
    self.xp_url = data.url unless data.url.nil?
    self.xp_start_date = data.start_date unless data.start_date.nil?
    self.xp_end_date = data.end_date unless data.end_date.nil?
    self.xp_job_description = data.job_description unless data.job_description.nil?
    self.xp_team = team unless team.nil?
  end
end
