set :branch, ENV.fetch('BRANCH', 'dev')
server "demo-gtd-bot.learnersguild.org",
  user: "lunar",
  roles: %w{web app db}
set :user, 'lunar'
