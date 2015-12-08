class AddUsersToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :users, :text, default: "[]"
  end
end
