class RolesRepository
  def existing(team)
    Role.where(asana_team_id: team.asana_id)
  end
end
