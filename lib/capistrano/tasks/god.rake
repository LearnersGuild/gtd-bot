namespace :god do
  desc "Copy configuration god"
  task :copy_configuration do
    on roles(:app) do
      within fetch(:release_path) do
        execute :cp, "config/god.rb", "#{shared_path}/config/god.rb"
      end
    end
  end

  desc "Restarts god"
  task :restart do
    on roles(:app) do
      execute "/etc/init.d/god restart"
    end
  end
end

