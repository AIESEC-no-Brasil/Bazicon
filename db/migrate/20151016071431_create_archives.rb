class CreateArchives < ActiveRecord::Migration
  def change
    create_table :archives do |t|
      t.string :name
      t.string :owner

      t.timestamps null: false
    end
  end
end
