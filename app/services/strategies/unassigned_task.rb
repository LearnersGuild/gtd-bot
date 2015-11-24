module Strategies
  class UnassignedTask < BaseStrategy
    takes :projects_filter, :tasks_filter_factory, :tasks_assigner

    def perform
      projects_with_tasks = projects_filter.without_roles_with_tasks
      projects_with_tasks.each do |project|
        tasks = project.tasks
        tasks_filter = tasks_filter_factory.new(tasks)
        unassigned_tasks = tasks_filter.unassigned
        tasks_assigner.perform(unassigned_tasks, project.owner_id)
      end
    end
  end
end
