class CreateTraineePeople < ActiveRecord::Migration
  def change
    create_table :trainee_people do |t|
      t.string :full_name
      t.datetime :arrival_date
      t.datetime :departure_date
      t.integer :local_committee

      t.timestamps null: false
    end
  end
end
