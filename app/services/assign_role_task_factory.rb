class AssignRoleTaskFactory < BaseService
  takes :tasks_repository

  TITLE = "Assign role to the project"
  DESCRIPTION = "Assign a role to %s by linking "\
                "to it in the description field. "\
                "Use the @ symbol to make it an active link"

  def create(project)
    name = "#{TITLE} #{project.name}"
    task = project.tasks.detect { |t| t.name == name }
    return if task

    task_attributes = {
      name: name,
      assignee: project.owner_id,
      notes: description(project)
    }
    tasks_repository.create(project, task_attributes)
  end

  private

  def description(project)
    DESCRIPTION % project.link
  end
end
