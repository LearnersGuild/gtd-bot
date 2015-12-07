class RolesRepository
  def all
    Role.all
  end

  def existing_without_special(team)
    Role.where(asana_team_id: team.asana_id)
      .where.not(name: ProjectObject::SPECIAL_NAMES)
  end

  def all_for_team(team)
    Role.where(asana_team_id: team.asana_id)
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
