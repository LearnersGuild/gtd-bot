class TasksAssigner < BaseService
  takes :tasks_repository

  def perform(tasks, assignee_id)
    tasks.each do |task|
      tasks_repository.update(task, assignee: assignee_id)
    end
  end
end
