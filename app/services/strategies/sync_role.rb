module Strategies
  class SyncRole < BaseStrategy
    takes :projects_filter, :team, :asana_client, :roles_repository,
      :asana_roles_updater_factory, :roles_diff_factory,
      :roles_saver, :role_object_factory

    def perform
      existing_roles = roles_repository.existing(team)
      roles_diff = roles_diff_factory.new(team.roles, existing_roles,
                                          role_object_factory)
      diff = roles_diff.perform
      asana_roles_updater = asana_roles_updater_factory.new(asana_client,
                                                            projects_filter)
      updated_diff = asana_roles_updater.perform(diff)
      roles_saver.perform(updated_diff)
    end
  end
end
