class StrategiesFactory < BaseService
  takes :asana_hierarchy_fetcher

  def create(team)
    logger.info("Fetching hierarchy...")
    projects = asana_hierarchy_fetcher.projects(team)
    logger.info("Hierarchy fetched")

    projects_filter = ProjectsFilter.new(projects)

    [
      injector.sync_role_strategy(team),
      injector.next_action_task_strategy(projects_filter),
      injector.unassigned_task_strategy(projects_filter),
      injector.individual_role_strategy(projects_filter, team),
      #injector.assign_role_to_tasks_strategy(projects_filter),
      injector.assign_role_task_strategy(projects_filter)
      #injector.clean_projects_names(projects_filter, team),
      #injector.stale_task(projects_filter)
    ]
  end
end
