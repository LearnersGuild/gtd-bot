module Strategies
  class UnassignedTask
    attr_accessor :projects_filter, :tasks_filter_factory, :tasks_assigner

    def initialize(projects_filter, tasks_filter_factory, tasks_assigner)
      self.projects_filter = projects_filter
      self.tasks_filter_factory = tasks_filter_factory
      self.tasks_assigner = tasks_assigner
    end

    def perform
      projects_with_tasks = projects_filter.with_tasks
      projects_with_tasks.each do |project|
        tasks = project.tasks
        tasks_filter = tasks_filter_factory.new(tasks)
        unassigned_tasks = tasks_filter.unassigned
        tasks_assigner.perform(unassigned_tasks, project.owner_id)
      end
    end
  end
end
