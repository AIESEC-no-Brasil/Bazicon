class SetColumnNamesEqual < ActiveRecord::Migration[5.1]
  def change
    rename_column :trainee_people, :arrival_date, :entry_date
  end
end
