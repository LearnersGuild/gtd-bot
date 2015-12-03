module Strategies
  class StaleTask < BaseStrategy
    takes :projects_repository, :tasks_repository_factory,
      :task_tagger_factory, :tags_repository

    def perform
      projects = projects_repository.with_tasks
      projects.each do |project|
        tasks_repository = tasks_repository_factory.new(project.tasks)
        logger.info(
          "Creating tags for stale tasks for project #{project.name}...")
        task_tagger = task_tagger_factory.new(tags_repository)
        task_tagger.perform(tasks_repository.stale_tasks,
                            TaskObject::STALE_TAG_NAME)
        logger.info("Tags for stale tasks created")
      end
    end
  end
end
