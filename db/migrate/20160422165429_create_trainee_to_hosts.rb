class CreateTraineeToHosts < ActiveRecord::Migration[5.1]
  def change
    create_table :trainee_to_hosts do |t|
      t.integer :host_id
      t.integer :trainee_id
      t.timestamp :entry_date
      t.timestamp :leave_date
      t.integer :host_nps
      t.text :host_nps_commentary
      t.integer :trainee_nps
      t.text :trainee_nps_commentary

      t.timestamps null: false
    end
  end
end
