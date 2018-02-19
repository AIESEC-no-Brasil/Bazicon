class ChangesLocalCommitteeAttributes < ActiveRecord::Migration[5.1]
  def change
    rename_column :local_committees, :receiver_id, :recipient_id
  end
end
