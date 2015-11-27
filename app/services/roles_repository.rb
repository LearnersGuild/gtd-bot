class RolesRepository
  def all
    Role.all
  end

  def existing(team)
    Role.where(asana_team_id: team.asana_id).where.not(name: "Individual")
  end
end
