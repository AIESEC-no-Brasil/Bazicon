class CreateExpaOffices < ActiveRecord::Migration[5.1]
  def change
    create_table :expa_offices do |t|
      t.column :xp_id, :integer
      t.column :xp_name, :string
      t.column :xp_full_name, :string
      t.column :xp_url, :string

      t.timestamps null: false
    end
  end
end