class ServicesInjector
  include Dependor::AutoInject

  def teams_synchronizer
    TeamsSynchronizer.new(glass_frog_client, teams_repository,
                          asana_teams_updater, TeamsDiff, teams_saver,
                          team_object_factory)
  end

  def sync_role_strategy(projects_filter, team)
    Strategies::SyncRole.new(projects_filter, team, asana_client,
                             roles_repository, AsanaRolesUpdater, RolesDiff,
                             roles_saver, role_object_factory)
  end

  def next_action_task_strategy(projects_filter)
    Strategies::NextActionTask.new(projects_filter, next_action_task_factory)
  end

  def unassigned_task_strategy(projects_filter)
    Strategies::UnassignedTask.new(projects_filter, TasksFilter,
                                   tasks_assigner)
  end

  def individual_role_strategy(projects_filter, team)
    Strategies::IndividualRole.new(team, projects_filter, asana_client)
  end

  def assign_role_to_tasks_strategy(projects_filter)
    Strategies::AssignRoleToTasks.new(projects_filter, TasksFilter,
                                     tasks_role_creator)
  end

  def assign_role_task_strategy(projects_filter)
    Strategies::AssignRoleTask.new(projects_filter, assign_role_task_factory)
  end

  def clean_projects_names(projects_filter, team)
    Strategies::CleanProjectsNames.new(projects_filter, team,
                                       illegal_roles_renamer)
  end

  def stale_task(projects_filter)
    Strategies::StaleTask.new(projects_filter, TasksFilter, task_tagger)
  end

  def comment_forgotten_tasks(projects_filter)
    Strategies::CommentForgottenTasks.new(projects_filter, TasksFilter,
                                          asana_client)
  end

  def logger
    @logger ||= Logger.new($stdout).tap do |log|
      log.progname = self.class
    end
  end
end

