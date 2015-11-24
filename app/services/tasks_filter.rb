class TasksFilter < BaseService
  takes :tasks

  def unassigned
    uncompleted_tasks.reject(&:assignee_id)
  end

  def assigned_to(assignee_id)
    uncompleted_tasks.select { |t| t.assigned_to?(assignee_id) }
  end

  def stale_tasks
    uncompleted_tasks.select(&:stale_task?)
  end

  def forgotten_tasks
    stale_tasks.select(&:forgotten_task?)
  end

  def uncompleted_tasks
    tasks.select(&:uncompleted?)
  end
end
