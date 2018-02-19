class CreateLocalCommittees < ActiveRecord::Migration[5.1]
  def change
    create_table :local_committees do |t|
      t.integer :receiver_id
      t.string :name_key

      t.timestamps
    end
  end
end
