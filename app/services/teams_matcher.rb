class TeamsMatcher < BaseService
  takes :circles_fetcher, :asana_client, :team_object_factory

  def perform
    circles = circles_fetcher.perform
    teams = asana_client.teams(ENV.fetch('ASANA_WORKSPACE_ID'))

    circles.map do |circle|
      team = teams.detect { |t| t.name == circle.name }
      next unless team

      team_object_factory.build_merged(circle, team)
    end.compact
  end
end
