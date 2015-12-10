class AsanaHierarchyFetcher < BaseService
  takes :asana_client, :parallel_iterator

  def projects(team)
    logger.info("Fetching projects for team #{team.name}...")
    projects =
      asana_client.projects(A9n.asana[:workspace_id], team.asana_id)
    logger.info("Projects fetched")
    parallel_iterator.map(projects) { |project| map_project(project) }
  end

  def map_project(project)
    logger.info("Fetching tasks for project #{project.name}...")
    tasks = asana_client.tasks_for_project(project.asana_id)
    project.tasks = tasks
    logger.info("Tasks for #{project.name} fetched")
    project
  end
end
