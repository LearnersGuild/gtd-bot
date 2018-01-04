class AsanaHierarchyFetcher < BaseService
  takes :asana_client, :parallel_iterator

  def projects(team)
    logger.info("Fetching projects for team #{team.name}...")
    projects =
      asana_client.projects(ENV.fetch('ASANA_WORKSPACE_ID'), team.asana_id)
    logger.info("Projects fetched")
    collection = ProjectsCollection.new(projects)
    parallel_iterator.map(collection) { |project| map_project(project) }
  end

  private

  def map_project(project)
    logger.info("Fetching tasks for project #{project.name}...")
    tasks = asana_client.tasks_for_project(project.asana_id)
    project.tasks = parallel_iterator.map(tasks) { |task| map_task(task) }
    logger.info("Tasks for #{project.name} fetched")
    project
  end

  def map_task(task)
    subtasks = asana_client.subtasks_for_task(task.asana_id)
    task.subtasks = subtasks
    task
  end
end
