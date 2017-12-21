class AddPagarmeIdToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :pagarme_id, :integer
  end
end
