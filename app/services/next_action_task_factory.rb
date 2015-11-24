class NextActionTaskFactory < BaseService
  takes :asana_client

  TITLE = "Add next action to"

  def create(project)
    name = "#{TITLE} #{project.name}"
    attributes = { name: name, assignee: project.owner_id, notes: project.link }
    asana_client.create_task(A9n.asana[:workspace_id], project.asana_id,
                             attributes)
  end
end
