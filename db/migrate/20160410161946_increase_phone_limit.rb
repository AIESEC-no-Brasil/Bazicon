class IncreasePhoneLimit < ActiveRecord::Migration
  def change
  	change_column :host_people, :phone, :integer, :limit => 8
  end
end
