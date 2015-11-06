module Strategies
  class SyncRole
    attr_accessor :glass_frog, :asana, :roles_diff_factory, :roles_saver

    def initialize(glass_frog, asana, roles_diff_factory, roles_saver)
      self.glass_frog = glass_frog
      self.asana = asana
      self.roles_diff_factory = roles_diff_factory
      self.roles_saver = roles_saver
    end

    def perform
      roles = glass_frog.roles
      roles_diff = roles_diff_factory.new(roles)
      diff = roles_diff.perform
      asana.update(diff)
      roles_saver.perform(roles)
    end
  end
end
