RAILS_ROOT = ENV['RAILS_ROOT'] || File.expand_path('../../', __FILE__)

God.watch do |w|
  w.name = "bot"
  w.start = "ruby #{RAILS_ROOT}/workers/bot_worker.rb"
  w.log = "#{RAILS_ROOT}/log/god.log"

  w.keepalive
end
