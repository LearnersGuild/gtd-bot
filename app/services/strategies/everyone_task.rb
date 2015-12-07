module Strategies
  class EveryoneTask < BaseStrategy
    takes :projects_repository, :tasks_repository_factory, :team

    def perform
      projects_repository.everyone.each do |project|
        tasks_repository = tasks_repository_factory.new(project.tasks)
        tasks_repository.uncompleted_tasks.each do |task|
          team.users.each do |user|
            tasks_repository.create(nil, task_attributes(task, user, project))
          end
          tasks_repository.delete(task.asana_id)
        end
      end
    end

    private

    def task_attributes(task, user, project)
      {
        name: task.name,
        tags: task.tags.map(&:asana_id),
        assignee: user.asana_id,
        due_at: task.due_at,
        projects: task.project_ids - [project.asana_id]
      }
    end
  end
end
