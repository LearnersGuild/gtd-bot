class TeamsMatcher < BaseService
  takes :glass_frog_client, :asana_client, :team_object_factory

  def perform
    circles = glass_frog_client.circles
    teams = asana_client.teams(A9n.asana[:workspace_id])

    circles.map do |circle|
      team = teams.detect { |t| t.name == circle.name }
      next unless team

      team_object_factory.build_merged(circle, team)
    end.compact
  end
end
