class CreateHostPeople < ActiveRecord::Migration
  def change
    create_table :host_people do |t|

      t.string :full_name
      t.integer :phone
      t.string :email
      t.string :address
      t.integer :cep
      t.string :state
      t.string :city
      t.integer :house_type
      t.integer :trainees_vacancy
      t.integer :weeks_vacancy
      t.integer :newest_lc
      t.integer :how_got_to_know_aiesec
      t.integer :tmp_responsable
      t.datetime :date_approach
      t.datetime :date_alignment_meeting
      t.integer :tmp_who_realized_meeting
      t.boolean :is_favourite
      t.boolean :is_problematic
      t.boolean :is_non_grata_person
      t.text :is_non_grata_description

      t.timestamps null: false
    end
  end
end
