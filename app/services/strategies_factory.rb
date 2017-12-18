class StrategiesFactory < BaseService
  takes :asana_hierarchy_fetcher, :asana_client

  def create(team)
    logger.info("Fetching hierarchy...")
    projects = asana_hierarchy_fetcher.projects(team)
    logger.info("Hierarchy fetched")

    projects_collection = ProjectsCollection.new(projects)
    projects_repository = ProjectsRepository.new(asana_client,
                                                 projects_collection)
    tasks_repository_factory = TasksRepositoryFactory.new(asana_client)
    subtasks_repository_factory = SubtasksRepositoryFactory.new(asana_client)
    tags_repository = TagsRepository.new(asana_client)
    strategies_repository = StrategiesRepository.new

    [
      injector.sync_role_strategy(projects_repository, team),
      injector.clean_projects_names(projects_repository, team)
    ]
  end
end
