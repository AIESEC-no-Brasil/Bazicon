class CreateHostProblems < ActiveRecord::Migration[5.1]
  def change
    create_table :host_problems do |t|
      t.timestamp :reported_date
      t.text :problem_description
      t.integer :host_id

      t.timestamps null: false
    end
  end
end
