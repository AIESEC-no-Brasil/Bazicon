class CreateExpaManagers < ActiveRecord::Migration[5.0]
  def change
    create_table :expa_managers do |t|
      t.integer :xp_id
      t.string :name
      t.string :email
      t.string :profile_photo_url

      t.timestamps
    end
  end
end
