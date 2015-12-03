class TasksRepository < BaseRepository
  def create(project, task_attributes)
    task = asana_client.create_task(A9n.asana[:workspace_id], project.asana_id,
                                    task_attributes)
    project.tasks.push(task)
  end

  def update(task, attributes)
    new_attributes = task.attributes.merge(attributes)
    asana_client.update_task(task.asana_id, new_attributes)
    task.update(new_attributes)
  end

  def add_comment_to_task(task, comment)
    asana_client.add_comment_to_task(task.asana_id, comment)
  end

  def add_project_to_task(task, project_id)
    return if task.project_ids.include?(project_id)

    asana_client.add_project_to_task(task, project_id)
    task.project_ids.push(project_id)
  end

  private

  def default_collection
    TasksRepository.new
  end
end
