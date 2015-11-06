desc 'Runs bot'
namespace :bot do
  task run: [:environment] do
    puts "Starting bot..."
    BotWorker.perform_async
    puts "Bot started"
  end
end
