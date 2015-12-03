module Strategies
  class CommentForgottenTasks < BaseStrategy
    takes :projects_repository, :tasks_repository_factory

    COMMENT = "Wow, you really don't seem to want to do this. "\
              "Maybe it's time to delegate or delete it!"

    def perform
      projects = projects_repository.with_tasks
      projects.each do |project|
        tasks_repository = tasks_repository_factory.new(project.tasks)
        logger.info(
          "Adding comments for forgotten tasks for project #{project.name}...")
        tasks_repository.forgotten_tasks.each do |task|
          tasks_repository.add_comment_to_task(task.asana_id, COMMENT)
        end
        logger.info("Comments for forgotten tasks created")
      end
    end
  end
end
