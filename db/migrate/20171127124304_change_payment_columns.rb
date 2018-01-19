class ChangePaymentColumns < ActiveRecord::Migration[5.0]
  def change
    change_column :payments, :program, 'integer USING CAST(program AS integer)'
    change_column :payments, :local_committee, 'integer USING CAST(local_committee AS integer)'
    add_column :payments, :tag, :string
    add_column :payments, :status, :integer
  end
end
