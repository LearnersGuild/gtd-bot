class ChangeGlassFrogIdInRoles < ActiveRecord::Migration
  def change
    change_column :roles, :glass_frog_id, :integer, null: true
  end
end
