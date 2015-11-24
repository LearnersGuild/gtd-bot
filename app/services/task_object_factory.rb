class TaskObjectFactory < BaseService
  def build_from_asana(task)
    TaskObject.new(
      asana_id: task.id,
      name: task.name,
      assignee_id: task.assignee && task.assignee['id'],
      description: task.notes,
      modified_at: DateTime.parse(task.modified_at),
      due_at: parse_due_at(task),
      tags: map_tags(task.tags),
      completed: task.completed
    )
  end

  private

  def map_tags(tags)
    tags.map { |tg| TagObject.new(asana_id: tg.id, name: tg.name) }
  end

  def parse_due_at(task)
    due = task.due_at || task.due_on
    due && DateTime.parse(due)
  end
end

