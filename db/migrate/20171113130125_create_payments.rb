class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.string :customer_name
      t.string :local_committee
      t.string :application_id
      t.string :program
      t.string :opportunity_name

      t.integer :value

      t.timestamps
    end
  end
end
