class TasksToRoleAdder < BaseService
  takes :tasks_repository
  inject :roles_repository

  def perform(project, tasks)
    tasks.each do |task|
      existing_roles = roles_repository.all
      role_ids = project.linked_role_ids(existing_roles)
      role_ids.each do |role_id|
        tasks_repository.add_project_to_task(task, role_id)
      end
    end
  end
end
