class CreateExpaOpportunities < ActiveRecord::Migration
  def change
    create_table :expa_opportunities do |t|
      t.column :xp_id, :integer
      t.column :xp_title, :string
      t.column :xp_url, :string
      t.column :xp_status, :integer #enum
      t.column :xp_location, :string
      t.column :xp_programmes, :text #json
      #TODO Fazer Many to Many com managers
      t.column :xp_office_id, :integer #foreigner_key (expa_office)
      t.column :xp_application_count, :integer
      t.column :xp_earliest_start_date, :date
      t.column :xp_latest_end_date, :date
      t.column :xp_applications_close_date, :date
      t.column :xp_profile_photo_url, :string

      t.timestamps null: false
    end
  end
end
