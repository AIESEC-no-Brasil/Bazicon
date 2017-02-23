class CreateExpaOpportunityManagers < ActiveRecord::Migration[5.0]
  def change
    create_table :expa_opportunity_managers do |t|
      t.integer :expa_opportunity_id
      t.integer :expa_manager_id

      t.timestamps
    end
  end
end
