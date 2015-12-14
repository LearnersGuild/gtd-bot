class PersonalTaskDuplicator < BaseService
  takes :tasks_repository, :parallel_iterator, :team, :project

  def perform
    tasks = tasks_repository.uncompleted_tasks
    parallel_iterator.each(tasks) do |task|
      team.users.each do |user|
        tasks_repository.create(nil, task_attributes(task, user))
      end
      tasks_repository.delete(task.asana_id)
    end
  end

  private

  def task_attributes(task, user)
    {
      name: task.name,
      tags: task.tags.map(&:asana_id),
      assignee: user.asana_id,
      due_at: task.due_at,
      due_on: task.due_on,
      projects: task.project_ids.reject { |id| id == project.asana_id }
    }
  end
end
