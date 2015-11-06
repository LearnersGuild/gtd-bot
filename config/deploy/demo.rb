set :branch, ENV.fetch('BRANCH', 'dev')
server "gtd-bot.demo.llp.pl",
  user: "lunar",
  roles: %w{web app db},
  port: 20_057
set :port, 20_057
set :user, 'lunar'
