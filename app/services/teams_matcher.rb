class TeamsMatcher < BaseService
  takes :glass_frog_client, :asana_client

  def perform
    circles = glass_frog_client.circles
    teams = asana_client.teams(A9n.asana[:workspace_id])

    circles.map do |circle|
      team = teams.detect { |t| t.name == circle.name }
      next unless team

      merge(circle, team)
    end.compact
  end

  private

  def merge(circle, team)
    circle.asana_id = team.asana_id
    circle.roles.each do |r|
      r.asana_team_id = team.asana_id
    end
    circle
  end
end
