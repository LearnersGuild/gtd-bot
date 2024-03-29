module Strategies
  class SyncRole < BaseStrategy
    takes :projects_repository, :team, :roles_repository,
      :asana_roles_updater_factory, :roles_diff_factory,
      :roles_saver, :role_object_factory

    def perform
      existing_roles = roles_repository.existing_without_special(team)
      roles_diff = roles_diff_factory.new(team.roles, existing_roles,
                                          role_object_factory)
      diff = roles_diff.perform
      asana_roles_updater = asana_roles_updater_factory.new(projects_repository)
      updated_diff = asana_roles_updater.perform(diff)
      roles_saver.perform(updated_diff)
    end
  end
end
