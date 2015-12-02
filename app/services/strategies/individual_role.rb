module Strategies
  class IndividualRole < BaseStrategy
    takes :team, :projects_repository, :roles_repository

    def perform
      logger.info("Creating individual role...")
      if projects_filter.individual.empty?
        role_attributes =
          ProjectAttributes.new(ProjectObject::INDIVIDUAL_ROLE, team.asana_id)
        project = projects_repository.create(role_attributes)
        roles_repository.create_from_project(project)
      end
      logger.info("Individual role created")
    end
  end
end
