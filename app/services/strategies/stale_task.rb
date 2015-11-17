module Strategies
  class StaleTask
    takes :projects_filter, :tasks_filter_factory, :task_tagger

    def perform
      projects = projects_filter.with_tasks
      projects.each do |project|
        tasks_filter = tasks_filter_factory.new(project.tasks)
        task_tagger.perform(tasks_filter.stale_tasks, 'stale')
      end
    end
  end
end
