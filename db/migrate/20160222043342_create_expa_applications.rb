class CreateExpaApplications < ActiveRecord::Migration
  def change
    create_table :expa_applications do |t|
      t.column :xp_id, :integer
      t.column :xp_url, :string
      #t.column :matchability :string
      t.column :xp_status, :integer #enum
      t.column :xp_current_status, :integer #enum
      #t.column :xp_favourite, :string
      t.column :xp_permissions, :text
      t.column :xp_created_at, :timestamp
      t.column :xp_updated_at, :timestamp

      t.column :xp_opportunity_id, :integer #foreigner_key (expa_opportunity)
      t.column :xp_interviewed, :boolean, default: false #done
      t.column :xp_person_id, :integer #foreigner_key lazy (expa_people)

      #new
      t.column :xp_an_signed_at, :timestamp
      t.column :xp_experience_start_date, :timestamp
      t.column :xp_experience_end_date, :timestamp
      t.column :xp_matched_or_rejected_at, :timestamp
      t.column :xp_date_matched, :timestamp
      t.column :xp_date_realized, :timestamp
      t.column :xp_date_completed, :timestamp
      t.column :xp_date_ldm_completed, :timestamp
      t.column :xp_paid, :boolean, default:false

      t.timestamps null: false
    end
  end
end
