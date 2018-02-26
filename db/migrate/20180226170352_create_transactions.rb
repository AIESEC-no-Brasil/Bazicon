class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.integer :payment_id
      t.integer :pagarme_id
      t.integer :status

      t.timestamps
    end
  end
end
