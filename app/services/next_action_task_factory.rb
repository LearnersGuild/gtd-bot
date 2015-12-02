class NextActionTaskFactory < BaseService
  takes :tasks_repository

  TITLE = "Add next action to"

  def create(project)
    name = "#{TITLE} #{project.name}"
    attributes = { name: name, assignee: project.owner_id, notes: project.link }

    logger.info("Creating next action task...")
    tasks_repository.create(project, attributes)
    logger.info("Next action task created")
  end
end
