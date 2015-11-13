class AsanaHierarchyFetcher < BaseService
  takes :asana_client

  def projects
    projects =
      asana_client.projects(A9n.asana[:workspace_id], A9n.asana[:team_id])
    projects.map do |project|
      tasks = asana_client.tasks_for_project(project.asana_id)
      project.tasks = tasks
      project
    end
  end
end
