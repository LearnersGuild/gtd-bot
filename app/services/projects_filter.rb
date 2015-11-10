class ProjectsFilter
  attr_accessor :projects, :asana_client

  def initialize(projects, asana_client)
    self.projects = projects
    self.asana_client = asana_client
  end

  def without_tasks
    projects.select do |project|
      asana_client.tasks_for_project(project.asana_id).empty?
    end
  end
end
