require 'logger'

class ServicesInjector
  include Dependor::AutoInject

  def projects_filter
    logger.info("Fetching hierarchy...")
    if @projects_filter
      logger.info("Hierarchy fetched")
      return @projects_filter
    end

    projects = asana_hierarchy_fetcher.projects
    logger.info("Hierarchy fetched")
    @projects_filter = ProjectsFilter.new(projects)
  end

  def sync_role_strategy
    Strategies::SyncRole.new(glass_frog_client, asana_roles_updater,
                             RolesDiff, roles_saver, role_object_factory)
  end

  def next_action_task_strategy
    Strategies::NextActionTask.new(projects_filter, next_action_task_factory)
  end

  def unassigned_task_strategy
    Strategies::UnassignedTask.new(projects_filter, TasksFilter,
                                   tasks_assigner)
  end

  def individual_role_strategy
    Strategies::IndividualRole.new(projects_filter, asana_client)
  end

  def assign_role_to_tasks_strategy
    Strategies::AssignRoleToTasks.new(projects_filter, TasksFilter,
                                     tasks_role_creator)
  end

  def assign_role_task_strategy
    Strategies::AssignRoleTask.new(projects_filter, assign_role_task_factory)
  end

  def clean_projects_names
    Strategies::CleanProjectsNames.new(projects_filter, glass_frog_client,
                                       illegal_roles_renamer)
  end

  def logger
    @logger ||= Logger.new($stdout).tap do |log|
      log.progname = self.class
    end
  end
end

