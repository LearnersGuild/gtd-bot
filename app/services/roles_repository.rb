class RolesRepository
  def all
    Role.all
  end

  def existing_without_individual(team)
    Role.where(asana_team_id: team.asana_id)
      .where.not(name: ProjectObject::INDIVIDUAL_NAME)
  end

  def create_from(project, team)
    name = project.name.gsub(/^#{ProjectObject::ROLE_PREFIX}/, "")
    Role.create(
      name: name,
      asana_id: project.asana_id,
      asana_team_id: team.asana_id
    )
  end
end
