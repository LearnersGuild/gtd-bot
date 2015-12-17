class TasksRepository < BaseRepository
  def create(project, task_attributes)
    task = asana_client.create_task(A9n.asana[:workspace_id],
                                    project.try(:asana_id), task_attributes)
    project.tasks.push(task) if project && task

    task
  end

  def update(task, attributes)
    updated_task = asana_client.update_task(task.asana_id, attributes)
    return unless updated_task

    new_attributes = updated_task.attributes_to_update_from_asana
    task.update(new_attributes)
  end

  def add_comment_to_task(task, comment)
    asana_client.add_comment_to_task(task.asana_id, comment)
  end

  def add_project_to_task(task, project_id)
    return if task.project_ids.include?(project_id)

    success = asana_client.add_project_to_task(task.asana_id, project_id)
    task.project_ids.push(project_id) if success
  end

  def delete(task_id)
    success = asana_client.delete_task(task_id)
    collection.delete(task_id) if success
  end

  private

  def default_collection
    TasksCollection.new
  end
end
