module Strategies
  class AssignRoleToTasks < BaseStrategy
    takes :projects_repository, :tasks_repository_factory,
      :tasks_to_role_adder_factory

    def perform
      projects_with_tasks = projects_repository.without_roles_with_tasks
      projects_with_tasks.each do |project|
        tasks_repository = tasks_repository_factory.new(project.tasks)
        assigned_to_owner = tasks_repository.assigned_to(project.owner_id)

        logger.info("Adding roles to tasks")
        tasks_to_role_adder = tasks_to_role_adder_factory.new(tasks_repository)
        tasks_to_role_adder.perform(project, assigned_to_owner)
        logger.info("Roles to tasks added")
      end
    end
  end
end
