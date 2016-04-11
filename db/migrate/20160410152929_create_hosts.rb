class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|

      t.column :full_name, :string
      t.column :phone, :string
      t.column :email, :string
      t.column :address, :string
      t.column :postal_code, :integer
      t.column :state, :string
      t.column :city, :string
      t.column :house_type, :integer
      t.column :trainees_vacancy, :integer
      t.column :weeks_vacancy, :integer
      t.column :nearest_lc_id, :integer
      t.column :how_got_to_know_aiesec, :integer
      t.column :tmp_responsable_id, :integer
      t.column :date_approach, :timestamp
      t.column :date_alignment_meeting, :timestamp
      t.column :tmp_who_realized_meeting_id, :integer
      t.column :is_favourite, :boolean, default: false
      t.column :is_problematic, :boolean, default: false
      t.column :is_non_grata, :boolean, default: false
      t.column :non_grata_description, :text
      
      t.timestamps null: false
    end

    create_table :host_problems do |t|
      t.column :reported_date, :timestamp
      t.column :problem_description, :text
      t.column :host_id, :integer

      t.timestamps null: false
    end

    create_table :host_people do |t|
      t.column :host_id, :integer #foreigner_key (Host)
      t.column :person_id, :integer #foreigner_key (ExpaPerson)
      t.column :entry_date, :timestamp
      t.column :leave_date, :timestamp
      t.column :host_nps, :integer
      t.column :host_nps_commentary, :text
      t.column :trainee_nps, :integer
      t.column :trainee_nps_commentary, :text 

      t.timestamps null: false
    end
  end
end
