namespace :clean do
  desc "Clean roles in db"
  task roles: :environment do
    Role.delete_all
  end
end
