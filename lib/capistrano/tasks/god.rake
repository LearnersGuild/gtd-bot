namespace :god do
  desc "Restarts god"
  task :restart do
    on roles(:app) do
      execute "/etc/init.d/god restart"
    end
  end
end

