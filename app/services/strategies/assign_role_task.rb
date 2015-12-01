module Strategies
  class AssignRoleTask < BaseStrategy
    takes :projects_filter, :assign_role_task_factory

    def perform
      projects_without_roles = projects_filter.without_roles_assigned
      projects_without_roles.each do |project|
        logger.info("Creating assign role task for project #{project.name}...")
        assign_role_task_factory.create(project)
        logger.info("Assign role task created")
      end
    end
  end
end
