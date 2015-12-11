class TasksCollection < BaseCollection
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
    select(&:uncompleted?)
  end

  def with_subtasks
    select { |t| t.subtasks.any? }
  end
end
