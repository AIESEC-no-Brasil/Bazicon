class SetColumnNamesEqual < ActiveRecord::Migration
  def change
    rename_column :trainee_people, :arrival_date, :entry_date
  end
end
