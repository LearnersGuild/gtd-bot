class RoleObjectFactory
  def from_db(role)
    RoleObject.new(
      glass_frog_id: role.glass_frog_id,
      name: role.name,
      asana_id: role.asana_id,
      asana_team_id: role.asana_team_id
    )
  end

  def from_glass_frog(role)
    RoleObject.new(glass_frog_id: role.id, name: role.name)
  end
end
