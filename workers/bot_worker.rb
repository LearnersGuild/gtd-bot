require File.expand_path('../../config/environment', __FILE__)

class BotWorker < BaseService
  inject :strategies_factory, :exception_handler

  def perform
    loop do
      logger.info("Starting bot...")

      logger.info("Creating strategies")
      strategies = strategies_factory.create
      logger.info("Strategies created")

      Bot.new(strategies, exception_handler).perform

      logger.info("Bot finished.")
      logger.info("Sleeping...")

      sleep 5
    end
  end
end

BotWorker.new.perform
