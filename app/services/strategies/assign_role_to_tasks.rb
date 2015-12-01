module Strategies
  class AssignRoleToTasks < BaseStrategy
    takes :projects_filter, :task_filter_factory, :tasks_to_role_adder

    def perform
      projects_with_tasks = projects_filter.without_roles_with_tasks
      projects_with_tasks.each do |project|
        logger.info("Adding roles for project #{project.name}")
        task_filter = task_filter_factory.new(project.tasks)
        assigned_to_owner = task_filter.assigned_to(project.owner_id)

        logger.info("Adding roles to tasks for project #{project.name}")
        tasks_to_role_adder.perform(project, assigned_to_owner)
        logger.info("Roles to tasks added")
      end
    end
  end
end
