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
    tags_repository = TagsRepository.new(asana_client)

    [
      injector.sync_role_strategy(projects_repository, team),
      injector.clean_projects_names(projects_repository, team),
      injector.next_action_task_strategy(projects_repository,
                                         tasks_repository_factory),
      injector.unassigned_task_strategy(projects_repository,
                                        tasks_repository_factory),
      injector.individual_role_strategy(projects_repository, team),
      injector.everyone_role_strategy(projects_repository, team),
      injector.assign_role_to_tasks_strategy(projects_repository,
                                             tasks_repository_factory),
      injector.assign_role_task_strategy(projects_repository),
      injector.stale_task(projects_repository, tasks_repository_factory,
                          tags_repository),
      injector.comment_forgotten_tasks(projects_repository,
                                       tasks_repository_factory)
      #injector.everyone_task(projects_repository, team)

    ]
  end
end
