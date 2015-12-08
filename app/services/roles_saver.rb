class RolesSaver
  def perform(diff)
    create_roles(diff[:to_create])
    delete_roles(diff[:to_delete])
    update_roles(diff[:to_update])
  end

  private

  def create_roles(roles)
    roles ||= []
    roles.each do |role|
      attributes = attributes_to_update(role).merge(
        glass_frog_id: role.glass_frog_id,
        asana_id: role.asana_id,
        asana_team_id: role.asana_team_id
      )
      Role.create(attributes)
    end
  end

  def delete_roles(roles)
    roles ||= []
    Role.where(asana_id: roles.map(&:asana_id)).delete_all
  end

  def update_roles(roles)
    roles ||= []
    roles.each do |role|
      role_from_db = Role.where(glass_frog_id: role.glass_frog_id).first
      role_from_db && role_from_db.update(attributes_to_update(role))
    end
  end

  def attributes_to_update(role)
    {
      name: role.name,
      purpose: role.purpose,
      accountabilities: role.accountabilities,
      domains: role.domains
    }
  end
end
