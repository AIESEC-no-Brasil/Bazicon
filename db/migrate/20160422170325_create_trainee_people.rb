class CreateTraineePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :trainee_people do |t|
      t.string :full_name
      t.timestamp :arrival_date
      t.timestamp :leaving_date
      t.integer :local_committee

      t.timestamps null: false
    end
  end
end
