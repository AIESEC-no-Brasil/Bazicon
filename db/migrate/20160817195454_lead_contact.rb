class LeadContact < ActiveRecord::Migration[5.0]
  def change
    add_column :expa_people, :travel_interest, :integer
    add_column :expa_people, :want_contact_by_email, :boolean, :default => false
    add_column :expa_people, :want_contact_by_phone, :boolean, :default => false
    add_column :expa_people, :want_contact_by_whatsapp, :boolean, :default => false
  end
end
