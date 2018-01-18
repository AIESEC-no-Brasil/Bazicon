class AddSlugToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :slug, :string
    add_index :payments, :slug, unique: true
  end
end
