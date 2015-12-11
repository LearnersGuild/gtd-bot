class ProjectsRepository < BaseRepository
  def create(team_id, attributes)
    project = asana_client.create_project(
      A9n.asana[:workspace_id], team_id, attributes)
    collection.add(project) if project
  end

  def update(project, attributes)
    updated_project = asana_client.update_project(project.asana_id, attributes)
    project.update(updated_project.attributes) if project
  end

  def delete(project_id)
    success = asana_client.delete_project(project_id)
    collection.delete(project_id) if success
  end

  private

  def default_collection
    ProjectsCollection.new
  end
end
