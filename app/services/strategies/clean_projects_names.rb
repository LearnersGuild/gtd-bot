module Strategies
  class CleanProjectsNames < BaseStrategy
    takes :projects_filter, :team, :illegal_roles_renamer

    def perform
      roles_from_glass_frog = team.roles
      roles_from_asana = projects_filter.roles
      illegal_roles_renamer.perform(roles_from_glass_frog, roles_from_asana)
    end
  end
end
