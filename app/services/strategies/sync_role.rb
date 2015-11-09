module Strategies
  class SyncRole
    attr_accessor :glass_frog_client, :asana_client, :roles_diff_factory,
      :roles_saver

    def initialize(glass_frog_client, asana_client, roles_diff_factory,
                   roles_saver)
      self.glass_frog_client = glass_frog_client
      self.asana_client = asana_client
      self.roles_diff_factory = roles_diff_factory
      self.roles_saver = roles_saver
    end

    def perform
      roles = glass_frog_client.roles
      roles_diff = roles_diff_factory.new(roles)
      diff = roles_diff.perform
      asana_client.update(diff)
      roles_saver.perform(roles)
    end
  end
end
