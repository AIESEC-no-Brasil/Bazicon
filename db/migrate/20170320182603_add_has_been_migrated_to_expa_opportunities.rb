class AddHasBeenMigratedToExpaOpportunities < ActiveRecord::Migration[5.0]
  def change
    add_column :expa_opportunities, :has_been_migrated, :boolean, default: false
  end
end
