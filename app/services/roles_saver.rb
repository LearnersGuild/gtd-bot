class RolesSaver
  def perform(roles)
    roles.each do |role|
      Role.create(glass_frog_id: role.id, name: role.name)
    end
  end
end
