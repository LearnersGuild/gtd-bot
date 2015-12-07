class ProjectsRepository < BaseRepository
  def create(team_id, attributes)
    project = asana_client.create_project(
      A9n.asana[:workspace_id], team_id, attributes)
    collection.add(project)
  end

  def update(project_id, attributes)
    project = asana_client.update_project(project_id, attributes)
    project.update(attributes)
  end

  def delete(project_id)
    asana_client.delete_project(project_id)
    collection.delete(project_id)
  end

  private

  def default_collection
    ProjectsCollection.new
  end
end
