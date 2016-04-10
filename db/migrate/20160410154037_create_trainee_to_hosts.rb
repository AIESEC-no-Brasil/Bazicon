class CreateTraineeToHosts < ActiveRecord::Migration
  def change
    create_table :trainee_to_hosts do |t|
      t.datetime :entry_date
      t.datetime :exit_date
      t.integer :host_evaluation
      t.integer :trainee_evaluation

      t.timestamps null: false
    end
  end
end
