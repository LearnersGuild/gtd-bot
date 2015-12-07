module Strategies
  class EveryoneTask < BaseStrategy
    takes :projects_repository, :tasks_repository_factory, :team

    def perform
      projects_repository.everyone.each do |project|
        task_repository = tasks_repository_factory.new(project.tasks)
        tasks_repository.uncompleted_tasks.each do |task|
          team.users.each do |user|
            task_attributes = task.attributes.merge(assignee_id: user)
            task_repository.create(project, task_attributes)
          end
        end
        delete(task)
      end
    end
  end
end
