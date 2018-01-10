class ChangeTr2hostsColName < ActiveRecord::Migration[5.1]
  def change
    rename_column :trainee_to_hosts, :host_id, :host_person_id
    rename_column :trainee_to_hosts, :trainee_id, :trainee_person_id
    rename_column :trainee_to_hosts, :leave_date, :leaving_date
  end
end
