namespace :clean do
  desc "Clean roles in db"
  task :roles do
    on roles(:app) do
      within fetch(:release_path) do
        execute :rake, "clean:roles"
      end
    end
  end
end

