class CreateHostPeople < ActiveRecord::Migration
  def change
    create_table :host_people do |t|
      t.string :full_name
      t.string :phone
      t.string :email
      t.string :address
      t.integer :postal_code
      t.string :state
      t.string :city
      t.integer :house_type
      t.integer :trainees_vacancy
      t.integer :weeks_vacancy
      t.integer :nearest_lc_id
      t.integer :how_got_to_know_aiesec
      t.integer :tmp_responsable_id
      t.timestamp :date_approach
      t.timestamp :date_alignment_meeting
      t.integer :tmp_who_realized_meeting_id
      t.boolean :is_favourite
      t.boolean :is_problematic
      t.boolean :is_non_grata
      t.text :non_grata_description

      t.timestamps null: false
    end
  end
end
