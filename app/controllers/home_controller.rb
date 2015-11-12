class HomeController < ApplicationController
  def index
  end

  def test_bot
    asana_client = AsanaClient.new
    asana_roles_updater = AsanaRolesUpdater.new(asana_client)
    role_object_factory = RoleObjectFactory.new
    glass_frog_client = GlassFrogClient.new(role_object_factory)
    asana_hierarchy_fetcher = AsanaHierarchyFetcher.new(asana_client)
    projects = asana_hierarchy_fetcher.projects
    roles_saver = RolesSaver.new
    projects_filter = ProjectsFilter.new(projects)
    next_action_task_factory = NextActionTaskFactory.new(asana_client)

    strategies = [
      Strategies::SyncRole.new(glass_frog_client, asana_roles_updater,
                               RolesDiff, roles_saver, role_object_factory),
      Strategies::NextActionTask.new(projects_filter, next_action_task_factory)
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
