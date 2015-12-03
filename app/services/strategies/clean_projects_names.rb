module Strategies
  class CleanProjectsNames < BaseStrategy
    takes :projects_repository, :team, :illegal_roles_renamer_factory

    def perform
      roles_from_glass_frog = team.roles
      roles_from_asana = projects_repository.roles
      logger.info("Renaming illegal project names...")
      illegal_roles_renamer =
        illegal_roles_renamer_factory.new(projects_repository)
      illegal_roles_renamer.perform(roles_from_glass_frog, roles_from_asana)
      logger.info("Illegal project names renamed")
    end
  end
end
