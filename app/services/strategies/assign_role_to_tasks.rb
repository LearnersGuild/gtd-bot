module Strategies
  class AssignRoleToTasks
    attr_accessor :project_filter, :task_filter_factory, :tasks_role_creator

    def initialize(project_filter, task_filter_factory, tasks_role_creator)
      self.project_filter = project_filter
      self.task_filter_factory = task_filter_factory
      self.tasks_role_creator = tasks_role_creator
    end

    def perform
      projects_with_tasks = project_filter.with_tasks
      projects_with_tasks.each do |project|
        task_filter = task_filter_factory.new(project.tasks)
        assigned_to_owner = task_filter.assigned_to_owner(project.owner_id)
        tasks_role_creator.perform(assigned_to_owner)
      end
    end
  end
end
