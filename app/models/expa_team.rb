class ExpaTeam < ActiveRecord::Base

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
    self.xp_team_type = data.team_type unless data.team_type.nil?
    self.xp_url = data.url unless data.url.nil?
    self.xp_office = office unless office.nil?
  end
end
