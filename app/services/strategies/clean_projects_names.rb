module Strategies
  class CleanProjectsNames < BaseStrategy
    takes :projects_filter, :glass_frog_client, :illegal_roles_renamer

    def perform
      roles_from_glass_frog = glass_frog_client.roles
      roles_from_asana = projects_filter.roles
      illegal_roles_renamer.perform(roles_from_glass_frog, roles_from_asana)
    end
  end
end
