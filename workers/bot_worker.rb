require File.expand_path('../../config/environment', __FILE__)

class BotWorker < BaseService
  inject :bot

  def perform
    loop do
      logger.info("Starting bot...")

      bot.perform

      logger.info("Bot finished.")
      logger.info("Sleeping...")

      sleep 5
    end
  end
end

BotWorker.new.perform
