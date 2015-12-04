class NextActionTaskFactory < BaseService
  TITLE = "Add next action to"

  def create(tasks_repository, project)
    name = "#{TITLE} #{project.name}"
    attributes = { name: name, assignee: project.owner_id, notes: project.link }

    logger.info("Creating next action task for project #{project.name}...")
    tasks_repository.create(project, attributes)
    logger.info("Next action task created")
  end
end
