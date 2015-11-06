class BotWorker
  include Sidekiq::Worker

  def perform
    Bot.new([]).perform
  end
end

