module Strategies
  class StaleTask < BaseStrategy
    takes :projects_filter, :tasks_filter_factory, :task_tagger
    TAG_NAME = 'stale'

    def perform
      projects = projects_filter.with_tasks
      projects.each do |project|
        tasks_filter = tasks_filter_factory.new(project.tasks)
        task_tagger.perform(tasks_filter.stale_tasks, TAG_NAME)
      end
    end
  end
end
