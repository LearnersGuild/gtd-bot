module Strategies
  class NextActionTask < BaseStrategy
    takes :projects_filter, :next_action_task_factory

    def perform
      projects_without_tasks = projects_filter.without_roles.without_tasks
      projects_without_tasks.each do |project|
        logger.info("Creating next action task for #{project.name}")
        next_action_task_factory.create(project)
        logger.info("Created")
      end
    end
  end
end
