class AddRoleDetails < ActiveRecord::Migration
  def change
    add_column :roles, :purpose, :string
    add_column :roles, :accountabilities, :text
    add_column :roles, :domains, :text
  end
end
