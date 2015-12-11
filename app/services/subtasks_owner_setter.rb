class SubtasksOwnerSetter
  takes :subtasks_repository_factory, :subtasks_assigner

  def perform(tasks_repository)
    tasks_repository.with_subtasks.each do |task|
      subtasks_repository = subtasks_repository_factory.new(task.subtasks)
      unassigned_subtasks = subtasks_repository.unassigned
      subtasks_assigner.perform(unassigned_subtasks, task.assignee_id)
    end
  end
end
