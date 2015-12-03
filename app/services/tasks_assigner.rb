class TasksAssigner < BaseService
  takes :asana_client, :parallel_iterator

  def perform(tasks, assignee_id)
    parallel_iterator.each(tasks) do |task|
      asana_client.update_task(task.asana_id, assignee: assignee_id)
    end
  end
end
