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
    project(project_id).delete
  end

  def update_project(project_id, attributes)
    project(project_id).update(attributes)
  end

  def projects(workspace_id, team_id)
    projects =
      Asana::Project.find_all(client, workspace: workspace_id, team: team_id)
    projects.map { |p| ProjectObject.new(asana_id: p.id, name: p.name) }
  end

  def tasks_for_project(project_id)
    project(project_id)
      .tasks.map { |t| TaskObject.new(asana_id: t.id, name: t.name) }
  end

  private

  def project(id)
    Asana::Project.new({ id: id }, { client: client })
  end
end
