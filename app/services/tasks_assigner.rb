class TasksAssigner
  attr_accessor :asana_client

  def initialize(asana_client)
    self.asana_client = asana_client
  end

  def perform(tasks, assignee_id)
    tasks.each do |task|
      asana_client.assign_task(task.asana_id, assignee_id)
    end
  end
end
