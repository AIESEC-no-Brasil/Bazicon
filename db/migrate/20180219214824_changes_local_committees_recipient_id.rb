class ChangesLocalCommitteesRecipientId < ActiveRecord::Migration[5.1]
  def change
    change_column :local_committees, :recipient_id, :string
  end
end
