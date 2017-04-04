class AddPodioIDs < ActiveRecord::Migration[5.0]
  def change
    add_column :expa_people, :podio_id, :integer
    add_column :expa_people, :interested_sdg, :integer
    add_column :expa_applications, :podio_id, :integer
  end
end
