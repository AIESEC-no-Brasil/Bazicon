class ExpaOffice < ActiveRecord::Base

  has_many :people_on_home_lc, class_name: 'ExpaPerson', foreign_key:'xp_home_lc_id'
  has_many :people_on_home_mc, class_name: 'ExpaPerson', foreign_key:'xp_home_mc_id'
  has_many :people_on_current_office, class_name: 'ExpaPerson', foreign_key:'xp_current_office_id'
  has_many :people_on_entity_exchange_lc, class_name: 'ExpaPerson', foreign_key:'entity_exchange_lc_id'
  has_many :archives_at_this_office, class_name: 'Archive', foreign_key: 'office_id'
  has_many :host_at_office, class_name: 'Host', foreign_key: 'nearest_lc_id'

  belongs_to :xp_parent, class_name: 'ExpaOffice'

  validates :xp_id,
            presence: false

  def update_from_expa(data, entity_name = nil)
    unless data.parent_id.nil? && data.tag = 'LC'
      parent = ExpaOffice.find_by_xp_id(data.parent_id)
      parent = ExpaOffice.new if parent.nil?
      parent.update_from_expa(Office.new(EXPA::Offices.list_single_office(data.parent_id)))
      parent.save
    end

    self.xp_full_name = data.full_name unless data.full_name.nil?
    self.xp_id = data.id unless data.id.nil?
    self.xp_parent = parent unless parent.nil?
    self.xp_url = data.url.to_s unless data.url.nil?
    self.xp_tag = data.tag.to_s unless data.tag.nil?

    self.xp_name = if entity_name.nil?
                     data.name unless data.name.nil?
                   else
                     entity_name
                   end
  end

  def is_mc?
    ExpaPerson.where(:xp_home_mc_id => self.id).count > 0
  end

  def is_lc?
    ExpaPerson.where(:xp_home_lc_id => self.id).count > 0
  end
end