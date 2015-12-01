class AsanaHierarchyFetcher < BaseService
  takes :asana_client

  def projects(team)
    logger.info("Fetching projects for team #{team.name}...")
    projects =
      asana_client.projects(A9n.asana[:workspace_id], team.asana_id)
    logger.info("Projects fetched")
    projects.map { |project| map_project(project) }
  end

  def map_project(project)
    logger.info("Fetching tasks for project #{project.name}...")
    tasks = asana_client.tasks_for_project(project.asana_id)
    logger.info("Tasks fetched")
    project.tasks = tasks
    project
  end
end
