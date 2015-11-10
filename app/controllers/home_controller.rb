class HomeController < ApplicationController
  def index
  end

  def test_bot
    asana_client = AsanaClient.new
    asana_roles_updater = AsanaRolesUpdater.new(asana_client)
    role_object_factory = RoleObjectFactory.new
    glass_frog_client = GlassFrogClient.new(role_object_factory)
    projects =
      asana_client.projects(A9n.asana[:workspace_id], A9n.asana[:team_id])
    strategies = [
      Strategies::SyncRole.new(glass_frog_client, asana_roles_updater,
                               RolesDiff, RolesSaver.new, role_object_factory),
      Strategies::NextActionTask.new(ProjectsFilter.new(projects, asana_client))
    ]

    response = Bot.new(strategies).perform
    render :test_bot, locals: { response: response }
  end

  def clear_cache
    Role.delete_all
    asana_client = AsanaClient.new
    projects = Asana::Project.find_by_team(asana_client.client,
                                           team: A9n.asana[:team_id])
    projects.each(&:delete)
  end
end
