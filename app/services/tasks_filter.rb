class TasksFilter < BaseService
  takes :tasks

  def unassigned
    tasks.reject(&:assignee_id)
  end

  def assigned_to(assignee_id)
    tasks.select { |t| t.assigned_to?(assignee_id) }
  end

  def stale_tasks
    tasks.select(&:stale_task?)
  end

  def forgotten_tasks
    stale_tasks.select(&:forgotten_task?)
  end
end
