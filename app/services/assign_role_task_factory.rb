class AssignRoleTaskFactory < BaseService
  takes :asana_client

  TITLE = "Assign role to the project"
  DESCRIPTION = "Assign a role to this project by linking "\
                "to it in the description field. "\
                "Use the @ symbol to make it an active link"

  def create(project)
    name = "#{TITLE} @#{project.name}"
    task = project.tasks.detect { |t| t.name == name }
    return if task

    attributes = { name: name, assignee: project.owner_id, notes: DESCRIPTION }
    workspace_id = A9n.asana[:workspace_id]
    asana_client.create_task(workspace_id, project.asana_id, attributes)
  end
end
