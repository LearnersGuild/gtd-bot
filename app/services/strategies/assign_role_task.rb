module Strategies
  class AssignRoleTask < BaseStrategy
    takes :projects_repository, :assign_role_task_factory

    def perform
      projects_without_roles = projects_repository.without_roles_assigned
      projects_without_roles.each do |project|
        logger.info("Creating assign role task...")
        assign_role_task_factory.create(project)
        logger.info("Assign role task created")
      end
    end
  end
end
