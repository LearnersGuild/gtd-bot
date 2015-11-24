class TasksToRoleAdder < BaseService
  takes :description_parser, :asana_client

  def perform(project, tasks)
    tasks.each do |task|
      roles = description_parser.roles(project.description)
      roles.each do |project_id|
        asana_client.add_project_to_task(task.asana_id, project_id)
      end
    end
  end
end
