class AsanaHierarchyFetcher
  attr_accessor :asana_client

  def initialize(asana_client)
    self.asana_client = asana_client
  end

  def projects
    projects =
      asana_client.projects(A9n.asana[:workspace_id], A9n.asana[:team_id])
    projects.map do |project|
      detailed_project = asana_client.project(project.asana_id)
      tasks = asana_client.tasks_for_project(project.asana_id)
      detailed_project.tasks = tasks
      detailed_project
    end
  end
end
