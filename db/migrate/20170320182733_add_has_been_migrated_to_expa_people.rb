class AddHasBeenMigratedToExpaPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :expa_people, :has_been_migrated, :boolean, default: false
  end
end
