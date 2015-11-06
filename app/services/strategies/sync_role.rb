module Strategies
  class SyncRole
    attr_accessor :glass_frog, :asana, :roles_diff

    def initialize(glass_frog, asana, roles_diff)
      self.glass_frog = glass_frog
      self.asana = asana
      self.roles_diff = roles_diff
    end

    def perform
      roles = glass_frog.roles
      diff = roles_diff.diff(roles)
      asana.update(diff)
    end
  end
end
