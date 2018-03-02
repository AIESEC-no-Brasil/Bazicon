class RemoveStatusAndPagarmeIdFromPayments < ActiveRecord::Migration[5.1]
  def up
    Payment.find_each do |payment|
      payment.pagarme_transactions.create(pagarme_id: payment.pagarme_id, status: payment.status)
    end
    remove_column :payments, :pagarme_id
    remove_column :payments, :status
  end

  def down
    add_column :payments, :pagarme_id, :integer
    add_column :payments, :status, :integer

    Payment.find_each do |payment|
      pagarme_transaction = payment.pagarme_transactions.last
      payment.update(pagarme_id: pagarme_transaction.id, status: pagarme_transaction.status)
    end
  end
end
