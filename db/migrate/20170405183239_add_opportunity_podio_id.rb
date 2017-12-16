class AddOpportunityPodioId < ActiveRecord::Migration[5.0]
  def change
    add_column :expa_opportunities, :podio_id, :integer
  end
end
