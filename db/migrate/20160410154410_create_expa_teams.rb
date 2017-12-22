class CreateExpaTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :expa_teams do |t|
      t.column :xp_id, :integer
      t.column :xp_title, :string
      t.column :xp_team_type, :string
      t.column :xp_url, :string
      t.column :xp_office_id, :integer #foreign_key (office)

      t.timestamps null: false
    end
  end
end
