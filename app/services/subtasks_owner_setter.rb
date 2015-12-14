class SubtasksOwnerSetter < BaseService
  takes :subtasks_repository_factory, :assigner_factory, :parallel_iterator

  def perform(tasks_repository)
    tasks_repository.with_subtasks.each do |task|
      subtasks_repository = subtasks_repository_factory.new(task.subtasks)
      subtasks_assigner =
        assigner_factory.new(subtasks_repository, parallel_iterator)
      unassigned_subtasks = subtasks_repository.unassigned
      subtasks_assigner.perform(unassigned_subtasks, task.assignee_id)
    end
  end
end
