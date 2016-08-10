class CreateSyncControls < ActiveRecord::Migration[5.0]
  def change
    create_table :sync_controls do |t|
      t.datetime :start
      t.datetime :end
      t.text :sync_type
      t.integer :count_itens
      t.boolean :get_error

      t.timestamps
    end
    rename_column :sync_controls, :start, :start_sync
    rename_column :sync_controls, :end, :end_sync
  end
end
