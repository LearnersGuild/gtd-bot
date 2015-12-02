class StrategiesFactory < BaseService
  takes :asana_hierarchy_fetcher, :asana_client

  def create(team)
    logger.info("Fetching hierarchy...")
    projects = asana_hierarchy_fetcher.projects(team)
    logger.info("Hierarchy fetched")

    projects_collection = ProjectsCollection.new(projects)
    projects_repository = ProjectsRepository.new(projects_collection,
                                                 asana_client)

    [
      injector.sync_role_strategy(projects_repository, team),
      injector.next_action_task_strategy(projects_repository),
      injector.unassigned_task_strategy(projects_repository),
      injector.individual_role_strategy(projects_repository, team),
      injector.assign_role_to_tasks_strategy(projects_repository),
      injector.assign_role_task_strategy(projects_repository),
      injector.clean_projects_names(projects_repository, team),
      injector.stale_task(projects_repository),
      injector.comment_forgotten_tasks(projects_repository)
    ]
  end
end
