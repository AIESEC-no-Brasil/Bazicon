class OfficeParent < ActiveRecord::Migration[5.0]
  def change
    add_column :expa_offices, :xp_parent_id, :integer
    add_column :expa_offices, :xp_tag, :string
  end
end
