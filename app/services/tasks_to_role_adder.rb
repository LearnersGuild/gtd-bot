class TasksToRoleAdder < BaseService
  takes :roles_repository, :asana_client

  def perform(project, tasks)
    tasks.each do |task|
      existing_roles = roles_repository.all
      role_ids = project.linked_role_ids(existing_roles)
      role_ids.each do |role_id|
        asana_client.add_project_to_task(task.asana_id, role_id)
      end
    end
  end
end
