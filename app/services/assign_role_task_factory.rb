class AssignRoleTaskFactory < BaseService
  takes :asana_client

  TITLE = "Assign role to the project"
  DESCRIPTION = "Assign a role to this project by linking
                 to it in the description field.
                 Use the @ symbol to make it an active link"

  def create(project)
    name = "#{TITLE} @#{project.name}"
    attributes = { name: name, assignee: project.owner_id, notes: DESCRIPTION }
    asana_client.create_task(A9n.asana[:workspace_id], project.asana_id,
                             attributes)
  end
end
