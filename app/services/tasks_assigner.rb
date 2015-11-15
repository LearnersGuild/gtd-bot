class TasksAssigner < BaseService
  takes :asana_client

  def perform(tasks, assignee_id)
    tasks.each do |task|
      asana_client.update_task(task.asana_id, assignee: assignee_id)
    end
  end
end
