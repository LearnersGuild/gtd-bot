module Strategies
  class AssignRoleTask < BaseStrategy
    takes :projects_repository, :assign_role_task_factory, :parallel_iterator

    def perform
      projects_without_roles = projects_repository.without_roles_assigned
      parallel_iterator.each(projects_without_roles) do |project|
        logger.info("Creating assign role task for project #{project.name}...")
        assign_role_task_factory.create(project)
        logger.info("Assign role task created")
      end
    end
  end
end
