class TaskObjectFactory < BaseService
  inject :tag_object_factory, :subtask_object_factory

  def build_from_asana(task, tags = [], memberships = [])
    TaskObject.new(
      asana_id: task.id,
      name: task.name,
      assignee_id: task.assignee && task.assignee['id'],
      description: task.notes,
      modified_at: DateTime.parse(task.modified_at),
      due_at: parse_due_at(task.due_at),
      due_on: parse_due_on(task.due_on),
      tags: map_tags(tags),
      completed: task.completed,
      project_ids: map_projects(memberships)
    )
  end

  private

  def map_tags(tags)
    tags.map { |tg| tag_object_factory.build_from_asana(tg) }
  end

  def map_projects(memberships)
    memberships.map { |m| m[:project][:id].to_s }
  end

  def parse_due_at(due_at)
    due_at && DateTime.parse(due_at)
  end

  def parse_due_on(due_on)
    due_on && Date.parse(due_on)
  end
end

