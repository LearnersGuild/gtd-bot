module Strategies
  class SyncRole < BaseService
    takes :glass_frog_client, :asana_roles_updater, :roles_diff_factory,
      :roles_saver, :role_object_factory

    def perform
      roles = glass_frog_client.roles
      roles_diff = roles_diff_factory.new(roles, role_object_factory)
      diff = roles_diff.perform
      updated_diff = asana_roles_updater.perform(diff)
      roles_saver.perform(updated_diff)
    end
  end
end
