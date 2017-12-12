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

  def unassigned_task_strategy(projects_repository, tasks_repository_factory)
    Strategies::UnassignedTask.new(projects_repository,
                                   tasks_repository_factory, Assigner,
                                   parallel_iterator)
  end

  def individual_role_strategy(projects_repository, team)
    Strategies::IndividualRole.new(team, projects_repository, roles_repository)
  end

  def everyone_role_strategy(projects_repository, team)
    Strategies::EveryoneRole.new(team, projects_repository, roles_repository)
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
                                       IllegalRolesRenamer, roles_repository,
                                       parallel_iterator)
  end

  def stale_task(projects_repository, tasks_repository_factory, tags_repository,
                strategies_repository)
    Strategies::StaleTask.new(projects_repository, tasks_repository_factory,
                              TaskTagger, tags_repository, parallel_iterator,
                              strategies_repository)
  end

  def comment_forgotten_tasks(projects_repository, tasks_repository_factory,
                              strategies_repository)
    Strategies::CommentForgottenTasks.new(projects_repository,
                                          tasks_repository_factory,
                                          strategies_repository,
                                          parallel_iterator)
  end

  def everyone_task(projects_repository, team)
    Strategies::EveryoneTask.new(projects_repository, tasks_repository_factory,
                                 team, PersonalTaskDuplicator,
                                 parallel_iterator)
  end

  def unassigned_subtask_strategy(projects_repository, tasks_repository_factory,
                                  subtasks_repository_factory)
    Strategies::UnassignedSubtask.new(projects_repository,
                                      tasks_repository_factory,
                                      subtasks_repository_factory,
                                      Assigner, SubtasksOwnerSetter,
                                      parallel_iterator)
  end
end
