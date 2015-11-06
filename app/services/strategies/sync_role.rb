module Strategies
  class SyncRole
    attr_accessor :glass_frog, :asana, :roles_diff, :roles_saver

    def initialize(glass_frog, asana, roles_diff, roles_saver)
      self.glass_frog = glass_frog
      self.asana = asana
      self.roles_diff = roles_diff
      self.roles_saver = roles_saver
    end

    def perform
      roles = glass_frog.roles
      diff = roles_diff.diff(roles)
      asana.update(diff)
      roles_saver.perform(roles)
    end
  end
end
