module Strategies
  class SyncRole
    attr_accessor :glass_frog_client, :asana_roles_updater, :roles_diff_factory,
      :roles_saver

    def initialize(glass_frog_client, asana_roles_updater, roles_diff_factory,
                   roles_saver)
      self.glass_frog_client = glass_frog_client
      self.asana_roles_updater = asana_roles_updater
      self.roles_diff_factory = roles_diff_factory
      self.roles_saver = roles_saver
    end

    def perform
      roles = glass_frog_client.roles
      roles_diff = roles_diff_factory.new(roles)
      diff = roles_diff.perform
      asana_roles_updater.perform(diff)
      roles_saver.perform(roles)
    end
  end
end
