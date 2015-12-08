class AddDefaultToAccountabilitiesAndDomains < ActiveRecord::Migration
  def change
    change_column :roles, :accountabilities, :text, default: "[]"
    change_column :roles, :domains, :text, default: "[]"
  end
end
