module Strategies
  class NextActionTask < BaseStrategy
    takes :projects_filter, :next_action_task_factory

    def perform
      projects_without_tasks = projects_filter.without_roles_and_tasks
      projects_without_tasks.each do |project|
        next_action_task_factory.create(project)
      end
    end
  end
end
