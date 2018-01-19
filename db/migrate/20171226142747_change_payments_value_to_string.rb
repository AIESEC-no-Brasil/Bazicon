class ChangePaymentsValueToString < ActiveRecord::Migration[5.1]
  def change
    change_column :payments, :value, :string
  end
end
