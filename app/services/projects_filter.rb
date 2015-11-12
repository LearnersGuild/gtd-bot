class ProjectsFilter
  attr_accessor :projects

  def initialize(projects)
    self.projects = projects
  end

  def without_tasks
    projects.select do |project|
      project.tasks.empty?
    end
  end
end
