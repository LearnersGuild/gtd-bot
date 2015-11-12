class ProjectsFilter
  attr_accessor :projects

  def initialize(projects)
    self.projects = projects
  end

  def without_tasks
    projects.select do |project|
      project.tasks.empty? && !project.a_role?
    end
  end
end
