class ProjectsFilter
  attr_accessor :projects

  def initialize(projects)
    self.projects = projects.reject(&:underscored?)
  end

  def without_tasks
    projects.select do |project|
      project.tasks.empty? && !project.a_role?
    end
  end

  def with_tasks
    projects.select do |project|
      project.tasks.any? && !project.a_role?
    end
  end

  def individual
    projects.select(&:individual?)
  end

  def roles
    projects.select(&:a_role?)
  end
end
