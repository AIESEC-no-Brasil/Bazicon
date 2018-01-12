class ChangePaymentsValueToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :payments, :value, 'integer USING CAST(value AS integer)'
  end
end
