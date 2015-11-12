class TasksFilter
  attr_accessor :tasks

  def initialize(tasks)
    self.tasks = tasks
  end

  def unassigned
    tasks.select { |task| task.assignee.empty? }
  end
end
