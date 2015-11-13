class TasksFilter
  attr_accessor :tasks

  def initialize(tasks)
    self.tasks = tasks
  end

  def unassigned
    tasks.reject(&:assignee_id)
  end

  def assigned_to(assignee_id)
    tasks.select { |t| t.assignee_id == assignee_id }
  end
end
