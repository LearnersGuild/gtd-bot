module Strategies
  class NextActionTask < BaseStrategy
    takes :projects_repository, :next_action_task_factory,
      :tasks_repository_factory, :parallel_iterator

    def perform
      projects_without_tasks = projects_repository.without_roles.without_tasks
      parallel_iterator.each(projects_without_tasks) do |project|
        logger.info("Creating next action task for #{project.name}")
        tasks_repository = tasks_repository_factory.new(project.tasks)
        next_action_task_factory.create(tasks_repository, project)
        logger.info("Created")
      end
    end
  end
end
