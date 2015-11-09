class RolesSaver
  def perform(diff)
    diff[:to_create].each do |role|
      Role.create(
        glass_frog_id: role.glass_frog_id,
        name: role.name,
        asana_id: role.asana_id
      )
    end
  end
end
