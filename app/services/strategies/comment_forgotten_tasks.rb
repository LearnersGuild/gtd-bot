module Strategies
  class CommentForgottenTasks < BaseStrategy
    takes :projects_filter, :tasks_filter_factory, :asana_client

    COMMENT = "Wow, you really don't seem to want to do this. "\
              "Maybe it's time to delegate or delete it!"

    def perform
      projects = projects_filter.with_tasks
      projects.each do |project|
        tasks_filter = tasks_filter_factory.new(project.tasks)
        tasks_filter.forgotten_tasks.each do |task|
          asana_client.add_comment_to_task(task.asana_id, COMMENT)
        end
      end
    end
  end
end
