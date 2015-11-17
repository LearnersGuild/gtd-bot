require File.expand_path('../../../config/environment', __FILE__)

class BotWorker < BaseWorker
  inject :strategies_factory, :exception_handler

  def perform
    loop do
      puts "Starting bot..."

      strategies = strategies_factory.create
      Bot.new(strategies, exception_handler).perform

      puts "Bot finished."
      puts "Sleeping..."

      sleep 5
    end
  end
end

BotWorker.new.perform
