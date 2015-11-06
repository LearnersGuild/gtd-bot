class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :glass_frog_id, null: false
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
