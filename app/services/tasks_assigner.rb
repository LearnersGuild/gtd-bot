class TasksAssigner < BaseService
  takes :tasks_repository, :parallel_iterator

  def perform(tasks, assignee_id)
    parallel_iterator.each(tasks) do |task|
      tasks_repository.update(task, assignee: assignee_id)
    end
  end
end
