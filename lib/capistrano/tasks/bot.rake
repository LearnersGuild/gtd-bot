namespace :bot do
  desc "Restarts bot"
  task :restart do
    on roles(:app) do
      execute "/usr/local/bin/god restart bot"
    end
  end
end

