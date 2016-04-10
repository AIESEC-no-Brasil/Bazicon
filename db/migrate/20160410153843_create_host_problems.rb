class CreateHostProblems < ActiveRecord::Migration
  def change
    create_table :host_problems do |t|
      t.datetime :reported_date
      t.text :problem_description

      t.timestamps null: false
    end
  end
end
