class AddAsanaIdToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :asana_id, :string, null: false
    add_index :roles, :asana_id
  end
end
