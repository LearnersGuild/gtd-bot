module Strategies
  class SyncRole
    attr_accessor :glass_frog_client, :asana_roles_updater, :roles_diff_factory,
      :roles_saver, :role_object_factory

    def initialize(glass_frog_client, asana_roles_updater, roles_diff_factory,
                   roles_saver, role_object_factory)
      self.glass_frog_client = glass_frog_client
      self.asana_roles_updater = asana_roles_updater
      self.roles_diff_factory = roles_diff_factory
      self.roles_saver = roles_saver
      self.role_object_factory = role_object_factory
    end

    def perform
      roles = glass_frog_client.roles
      roles_diff = roles_diff_factory.new(roles, role_object_factory)
      diff = roles_diff.perform
      updated_diff = asana_roles_updater.perform(diff)
      roles_saver.perform(updated_diff)
    end
  end
end
