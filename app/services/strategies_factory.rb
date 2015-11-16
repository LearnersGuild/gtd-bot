class StrategiesFactory < BaseService
  inject :sync_role_strategy, :next_action_task_strategy,
    :unassigned_task_strategy, :individual_role_strategy,
    :assign_role_to_tasks_strategy, :assign_role_task_strategy,
    :clean_projects_names

  def create
    [
      sync_role_strategy,
      next_action_task_strategy,
      unassigned_task_strategy,
      individual_role_strategy,
      assign_role_to_tasks_strategy,
      assign_role_task_strategy,
      clean_projects_names
    ]
  end
end
