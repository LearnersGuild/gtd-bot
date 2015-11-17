set :branch, ENV.fetch('BRANCH', 'master')
server "107.170.211.92",
  user: "lunar",
  roles: %w{web app db}
set :user, 'lunar'

after 'deploy:finished', 'god:copy_configuration'
after 'god:copy_configuration', 'god:restart'
after 'god:restart', 'bot:restart'
