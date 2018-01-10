class AddLocalCommitteeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :local_committee, :integer
  end
end
