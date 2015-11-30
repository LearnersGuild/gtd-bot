module Strategies
  class IndividualRole < BaseStrategy
    takes :team, :projects_filter, :asana_client

    def perform
      logger.info("Creating individual role...")
      if projects_filter.individual.empty?
        role_attributes =
          ProjectAttributes.new(ProjectObject::INDIVIDUAL_ROLE, team.asana_id)
        project = asana_client.create_project(role_attributes)
        save(project)
      end
      logger.info("Individual role created")
    end

    private

    def save(project)
      Role.create(
        name: decorate_name(project.name),
        asana_id: project.asana_id,
        asana_team_id: team.asana_id
      )
    end

    def decorate_name(name)
      name.gsub(/^#{ProjectObject::ROLE_PREFIX}/, "")
    end
  end
end
