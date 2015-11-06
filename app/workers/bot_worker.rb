class BotWorker
  include Sidekiq::Worker

  def perform
    strategies = [
      Strategies::SyncRole.new
    ]

    Bot.new(strategies).perform
  end
end

