class ProjectsFilter
  attr_accessor :projects

  def initialize(projects)
    self.projects = projects
    ignore_underscored_projects
  end

  def without_tasks
    projects.select do |project|
      project.tasks.empty? && !project.a_role?
    end
  end

  def with_tasks
    projects.select do |project|
      project.tasks.any?
    end
  end

  def individual
    projects.select(&:individual?)
  end

  private

  def ignore_underscored_projects
    self.projects = projects.reject(&:underscored?)
  end
end
