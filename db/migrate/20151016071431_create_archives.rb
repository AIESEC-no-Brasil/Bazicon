class CreateArchives < ActiveRecord::Migration
  def change
    create_table :archives do |t|
      t.column :name, :string
      t.column :office_id, :integer #foreigner_key (office)
      t.column :person_id, :integer #foreigner_key (people)

      t.timestamps null: false
    end
  end
end
