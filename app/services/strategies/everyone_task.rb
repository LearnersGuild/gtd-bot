module Strategies
  class EveryoneTask < BaseStrategy
    takes :projects_repository, :tasks_repository_factory, :team,
      :personal_task_duplicator_factory, :parallel_iterator

    def perform
      projects_repository.everyone.each do |project|
        logger.info("Duplicating tasks for #{project.name}")
        tasks_repository = tasks_repository_factory.new(project.tasks)
        personal_task_duplicator =
          personal_task_duplicator_factory.new(tasks_repository,
                                               parallel_iterator, team, project)
        personal_task_duplicator.perform
        logger.info("Duplicated")
      end
    end
  end
end
