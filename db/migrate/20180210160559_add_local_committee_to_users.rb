class AddLocalCommitteeToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :local_committee
    add_reference :users, :local_committee, foreign_key: true
  end
end
