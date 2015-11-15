module Strategies
  class AssignRoleToTasks < BaseService
    takes :project_filter, :task_filter_factory, :tasks_role_creator

    def perform
      projects_with_tasks = project_filter.with_tasks
      projects_with_tasks.each do |project|
        task_filter = task_filter_factory.new(project.tasks)
        assigned_to_owner = task_filter.assigned_to(project.owner_id)
        tasks_role_creator.perform(project, assigned_to_owner)
      end
    end
  end
end
