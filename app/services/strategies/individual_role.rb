module Strategies
  class IndividualRole < BaseStrategy
    takes :team, :projects_repository, :roles_repository

    def perform
      logger.info("Creating individual role...")
      if projects_repository.individual.empty?
        role_attributes = { name: ProjectObject::INDIVIDUAL_ROLE }
        project = projects_repository.create(team.asana_id, role_attributes)
        roles_repository.create_from(project, team)
      end
      logger.info("Individual role created")
    end
  end
end
