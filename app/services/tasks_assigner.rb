class TasksAssigner
  attr_accessor :asana_client

  def initialize(asana_client)
    self.asana_client = asana_client
  end

  def perform(tasks, assignee_id)
    tasks.each do |task|
      asana_client.update_task(task.asana_id, assignee: assignee_id)
    end
  end
end
