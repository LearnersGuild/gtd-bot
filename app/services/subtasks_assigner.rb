class SubtasksAssigner < BaseService
  takes :subtasks_repository, :parallel_iterator

  def perform(subtasks, assignee_id)
    parallel_iterator.each(subtasks) do |subtask|
      subtasks_repository.update(subtask, assignee: assignee_id)
    end
  end
end
