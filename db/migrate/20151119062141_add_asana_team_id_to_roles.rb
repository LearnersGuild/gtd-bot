class AddAsanaTeamIdToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :asana_team_id, :string, null: false
  end
end
