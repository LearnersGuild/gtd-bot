module Strategies
  class StaleTask < BaseStrategy
    takes :projects_filter, :tasks_filter_factory, :task_tagger

    def perform
      projects = projects_filter.with_tasks
      projects.each do |project|
        tasks_filter = tasks_filter_factory.new(project.tasks)
        logger.info("Creating tags for stale tasks...")
        task_tagger.perform(tasks_filter.stale_tasks,
                            TaskObject::STALE_TAG_NAME)
        logger.info("Tags for stale tasks created")
      end
    end
  end
end
