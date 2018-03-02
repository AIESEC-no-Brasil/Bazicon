class CreatePagarmeTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :pagarme_transactions do |t|
      t.integer :payment_id
      t.integer :pagarme_id
      t.integer :status

      t.timestamps
    end
  end
end
