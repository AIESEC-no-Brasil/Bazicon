class CreateExpaPersonManagers < ActiveRecord::Migration[5.0]
  def change
    create_table :expa_person_managers do |t|
      t.integer :expa_person_id
      t.integer :expa_manager_id

      t.timestamps
    end
  end
end
