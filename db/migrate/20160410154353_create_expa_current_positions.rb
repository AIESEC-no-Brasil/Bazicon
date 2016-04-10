class CreateExpaCurrentPositions < ActiveRecord::Migration
  def change
    create_table :expa_current_positions do |t|
      t.column :xp_id, :integer
      t.column :xp_position_name, :string
      t.column :xp_position_short_name, :string
      t.column :xp_url, :string
      t.column :xp_start_date, :timestamp
      t.column :xp_end_date, :timestamp
      t.column :xp_job_description, :text
      t.column :xp_team_id, :integer #foreign_key (teams)

      t.timestamps null: false
    end
  end
end
