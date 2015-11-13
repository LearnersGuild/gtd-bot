class TasksRoleCreator
  attr_accessor :task_description_builder, :asana_client

  def initialize(task_description_builder, asana_client)
    self.task_description_builder = task_description_builder
    self.asana_client = asana_client
  end

  def perform(project, tasks)
    tasks.each do |task|
      new_description =
        task_description_builder.with_project_roles(task, project)
      asana_client.update_task(task.asana_id, notes: new_description)
    end
  end
end
