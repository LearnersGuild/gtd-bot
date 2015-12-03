class ServicesInjector
  include Dependor::AutoInject

  def teams_synchronizer
    TeamsSynchronizer.new(glass_frog_client, teams_repository,
                          asana_teams_updater, TeamsDiff, teams_saver,
                          team_object_factory)
  end

  def sync_role_strategy(projects_repository, team)
    Strategies::SyncRole.new(projects_repository, team, roles_repository,
                             AsanaRolesUpdater, RolesDiff, roles_saver,
                             role_object_factory)
  end

  def next_action_task_strategy(projects_repository, tasks_repository_factory)
    Strategies::NextActionTask.new(projects_repository,
                                   next_action_task_factory,
                                   tasks_repository_factory)
  end

  def unassigned_task_strategy(projects_repository, tasks_repository_factory)
    Strategies::UnassignedTask.new(projects_repository,
                                   tasks_repository_factory, tasks_assigner)
  end

  def individual_role_strategy(projects_repository, team)
    Strategies::IndividualRole.new(team, projects_repository, roles_repository)
  end

  def assign_role_to_tasks_strategy(projects_repository,
                                    tasks_repository_factory)
    Strategies::AssignRoleToTasks.new(
      projects_repository, tasks_repository_factory, TasksToRoleAdder,
      parallel_iterator)
  end

  def assign_role_task_strategy(projects_repository)
    Strategies::AssignRoleTask.new(
      projects_repository, assign_role_task_factory, parallel_iterator)
  end

  def clean_projects_names(projects_repository, team)
    Strategies::CleanProjectsNames.new(projects_repository, team,
                                       IllegalRolesRenamer)
  end

  def stale_task(projects_repository, tasks_repository_factory, tags_repository)
    Strategies::StaleTask.new(projects_repository, tasks_repository_factory,
                              TaskTagger, tags_repository)
  end

  def comment_forgotten_tasks(projects_repository, tasks_repository_factory)
    Strategies::CommentForgottenTasks.new(projects_repository,
                                          tasks_repository_factory)
  end
end

