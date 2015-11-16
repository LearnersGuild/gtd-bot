class StrategiesFactory
  takes :asana_client, :asana_roles_updater, :role_object_factory,
        :glass_frog_client, :asana_hierarchy_fetcher, :roles_saver,
        :next_action_task_factory, :tasks_assigner, :description_parser,
        :task_description_builder, :tasks_role_creator, :illegal_roles_renamer

  def create
    projects = asana_hierarchy_fetcher.projects
    projects_filter = ProjectsFilter.new(projects)

    [
      Strategies::SyncRole.new(glass_frog_client, asana_roles_updater,
                               RolesDiff, roles_saver, role_object_factory),
      Strategies::NextActionTask.new(projects_filter, next_action_task_factory),
      Strategies::UnassignedTask.new(projects_filter, TasksFilter,
                                     tasks_assigner),
      Strategies::IndividualRole.new(projects_filter, asana_client),
      Strategies::AssignRoleToTasks.new(projects_filter, TasksFilter,
                                       tasks_role_creator),
      Strategies::CleanProjectsNames.new(projects_filter, glass_frog_client,
                                        illegal_roles_renamer)
    ]
  end
end
