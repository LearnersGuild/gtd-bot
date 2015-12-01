require File.expand_path('../../config/environment', __FILE__)

class BotWorker < BaseService
  PROFILER_OUTPUT_PATH = Rails.root.join("tmp", "profile.html")

  inject :bot

  def perform
    loop do
      if Rails.env.profile?
        perform_with_profiler
      else
        perform_iteration
      end
    end
  end

  def perform_iteration
    logger.info("Starting bot...")

    bot.perform

    logger.info("Bot finished.")
    logger.info("Sleeping...")

    sleep 5
  end

  def perform_with_profiler
    result = RubyProf.profile do
      foo
    end

    printer = RubyProf::GraphPrinter.new(result)
    File.open(PROFILER_OUTPUT_PATH, "w") { |f| printer.print(f) }
  end
end

BotWorker.new.perform
