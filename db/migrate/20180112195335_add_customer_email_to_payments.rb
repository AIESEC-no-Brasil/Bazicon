class AddCustomerEmailToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :customer_email, :string
  end
end
