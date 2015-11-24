class NextActionTaskFactory < BaseService
  takes :asana_client

  TITLE = "Add next action to"

  def create(project)
    name = "#{TITLE} #{project.name}"
    attributes = { name: name, assignee: project.owner_id, notes: project.link }

    logger.info("Creating next action task...")
    asana_client.create_task(A9n.asana[:workspace_id], project.asana_id,
                             attributes)
    logger.info("Next action task created")
  end
end
