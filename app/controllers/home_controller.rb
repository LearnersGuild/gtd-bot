class HomeController < ApplicationController
  def index
  end

  def test_bot
    asana_client = AsanaClient.new
    asana_roles_updater = AsanaRolesUpdater.new(asana_client)
    strategies = [
      Strategies::SyncRole.new(GlassFrogClient.new, asana_roles_updater,
                               RolesDiff, RolesSaver.new)
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
