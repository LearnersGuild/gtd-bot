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
end
