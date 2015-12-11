class SubtaskObjectFactory < BaseService
  def build_from_asana(subtask)
    SubtaskObject.new(
      asana_id: subtask.id,
      name: subtask.name,
      assignee_id: subtask.assignee && subtask.assignee['id'],
      completed: subtask.completed
    )
  end
end
