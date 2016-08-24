class ApplicationApprovedDate < ActiveRecord::Migration[5.0]
  def change
    add_column :expa_applications, :xp_date_approved, :timestamp
  end
end
