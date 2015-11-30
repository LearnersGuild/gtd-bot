class RolesRepository
  def all
    Role.all
  end

  def existing_without_individual(team)
    Role.where(asana_team_id: team.asana_id)
      .where.not(name: ProjectObject::INDIVIDUAL_NAME)
  end
end
