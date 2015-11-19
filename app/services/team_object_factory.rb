class TeamObjectFactory
  takes :role_object_factory

  def from_glass_frog(circle)
    roles = circle.roles.map { |r| role_object_factory.from_glass_frog(r) }
    TeamObject.new(
      glass_frog_id: circle.id,
      name: circle.short_name,
      roles: roles
    )
  end

  def from_asana(team)
    TeamObject.new(
      asana_id: team.id,
      name: team.name
    )
  end
end
