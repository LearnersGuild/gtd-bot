module Strategies
  class SyncRole < BaseStrategy
    takes :team, :roles_repository, :asana_roles_updater, :roles_diff_factory,
      :roles_saver, :role_object_factory

    def perform
      existing_roles = roles_repository.existing(team)
      roles_diff = roles_diff_factory.new(team.roles, existing_roles,
                                          role_object_factory)
      diff = roles_diff.perform
      updated_diff = asana_roles_updater.perform(diff)
      roles_saver.perform(updated_diff)
    end
  end
end
