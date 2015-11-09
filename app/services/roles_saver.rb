class RolesSaver
  def perform(diff)
    create_roles(diff[:to_create])
    delete_roles(diff[:to_delete])
  end

  private

  def create_roles(roles)
    roles ||= []
    roles.each do |role|
      Role.create(
        glass_frog_id: role.glass_frog_id,
        name: role.name,
        asana_id: role.asana_id
      )
    end
  end

  def delete_roles(roles)
    roles ||= []
    Role.where(asana_id: roles.map(&:asana_id)).delete_all
  end
end
