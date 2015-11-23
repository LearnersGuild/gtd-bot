class Bot < BaseService
  takes :teams_matcher, :strategies_factory, :exception_handler

  def perform
    teams = teams_matcher.perform
    teams.each do |team|
      logger.info("Creating strategies for #{team.name}")
      strategies = strategies_factory.create(team)
      logger.info("Strategies created")

      strategies.each do |strategy|
        begin
          strategy.perform_with_logging
        rescue StandardError => exception
          exception_handler.perform(exception)
        end
      end
    end
  end
end

