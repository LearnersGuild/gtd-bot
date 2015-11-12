class TasksFilter
  attr_accessor :tasks

  def initialize(tasks)
    self.tasks = tasks
  end

  def unassigned
    tasks.reject(&:assignee_id)
  end
end
