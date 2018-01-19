class AddPaymentMethodAndBoletoUrlToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :payment_method, :integer
    add_column :payments, :boleto_url, :string
  end
end
