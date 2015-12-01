class StrategiesFactory < BaseService
  takes :asana_hierarchy_fetcher

  def create(team)
    logger.info("Fetching hierarchy...")
    projects = asana_hierarchy_fetcher.projects(team)
    logger.info("Hierarchy fetched")

    projects_collection = ProjectsCollection.new(projects)

    [
      injector.sync_role_strategy(projects_collection, team),
      injector.next_action_task_strategy(projects_collection),
      injector.unassigned_task_strategy(projects_collection),
      injector.individual_role_strategy(projects_collection, team),
      injector.assign_role_to_tasks_strategy(projects_collection),
      injector.assign_role_task_strategy(projects_collection),
      injector.clean_projects_names(projects_collection, team),
      injector.stale_task(projects_collection),
      injector.comment_forgotten_tasks(projects_collection)
    ]
  end
end
