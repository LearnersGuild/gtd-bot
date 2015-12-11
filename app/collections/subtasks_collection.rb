class SubtasksCollection < BaseCollection
  def unassigned
    uncompleted_subtasks.reject(&:assignee_id)
  end

  def uncompleted_subtasks
    select(&:uncompleted?)
  end
end
