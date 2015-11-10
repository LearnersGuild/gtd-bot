module Strategies
  class NextActionTask
    attr_accessor :projects_filter, :next_action_task_factory

    def initialize(projects_filter, next_action_task_factory)
      self.projects_filter = projects_filter
      self.next_action_task_factory = next_action_task_factory
    end

    def perform
      projects_without_tasks = projects_filter.without_tasks
      projects_without_tasks.each do |project|
        next_action_task_factory.create(project)
      end
    end
  end
end
