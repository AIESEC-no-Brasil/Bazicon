class AddLocalCommitteeToPayments < ActiveRecord::Migration[5.1]
  def change
    remove_column :payments, :local_committee
    add_reference :payments, :local_committee, foreign_key: true
  end
end
