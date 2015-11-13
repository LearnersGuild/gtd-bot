class HomeController < ApplicationController
  inject :strategies_factory, :exception_handler

  def index
  end

  def test_bot
    strategies = strategies_factory.create
    response = Bot.new(strategies, exception_handler).perform

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
