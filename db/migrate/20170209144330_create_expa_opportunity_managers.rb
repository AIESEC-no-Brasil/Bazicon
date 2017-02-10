class CreateExpaOpportunityManagers < ActiveRecord::Migration[5.0]
  def change
    create_table :expa_opportunity_managers do |t|
      t.column :xp_id, :integer
      t.column :name, :string
      t.column :email, :string
      t.column :profile_photo_url, :string

      t.timestamps
    end
  end
end
