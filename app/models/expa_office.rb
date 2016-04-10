class ExpaOffice < ActiveRecord::Base
  has_many :people_on_home_lc, class_name: 'ExpaPerson', foreign_key:'xp_home_lc'
  has_many :people_on_home_mc, class_name: 'ExpaPerson', foreign_key:'xp_home_mc'
  has_many :people_on_current_office, class_name: 'ExpaPerson', foreign_key:'xp_current_office'
  has_many :people_on_entity_exchange_lc, class_name: 'ExpaPerson', foreign_key:'entity_exchange_lc'

  validates :xp_id,
            uniqueness: true,
            presence: false

  def update_from_expa(data)
    self.xp_full_name = data.full_name unless data.full_name.nil?
    self.xp_name = data.name unless data.name.nil?
    self.xp_id = data.id unless data.id.nil?
    self.xp_url = data.url.to_s unless data.url.nil?
  end
end
