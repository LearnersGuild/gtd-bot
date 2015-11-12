class AsanaClient
  attr_accessor :client

  def initialize
    self.client = Asana::Client.new do |c|
      c.authentication(:access_token, A9n.asana[:api_key])
    end
  end

  def create_project(attributes)
    Asana::Project.create(client, attributes)
  end

  def delete_project(project_id)
    build_project(project_id).delete
  end

  def update_project(project_id, attributes)
    build_project(project_id).update(attributes)
  end

  def projects(workspace_id, team_id)
    projects =
      Asana::Project.find_all(client, workspace: workspace_id, team: team_id)
    projects.map { |p| ProjectObject.new(asana_id: p.id, name: p.name) }
  end

  def project(project_id)
    project = Asana::Project.find_by_id(client, project_id)
    ProjectObject.new(
      asana_id: project.id,
      name: project.name,
      owner_id: project.owner['id']
    )
  end

  def create_task(workspace_id, project_id, attributes)
    merged_attributes = attributes.merge(
      workspace: workspace_id,
      projects: [project_id]
    )
    Asana::Task.create(client, merged_attributes)
  end

  def tasks_for_project(project_id)
    build_project(project_id)
      .tasks.map { |t| TaskObject.new(asana_id: t.id, name: t.name) }
  end

  def assign_task(task_id, assignee_id)
    attributes = {
      assignee: { id: assignee_id }
    }
    task(task_id).update(attributes)
  end

  private

  def build_project(id)
    Asana::Project.new({ id: id }, { client: client })
  end

  def task(id)
    Asana::Task.new({ id: id }, { client: client })
  end
end
