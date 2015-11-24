class ProjectsFilter
  attr_accessor :projects

  def initialize(projects)
    self.projects = projects.reject(&:underscored?)
  end

  def without_roles_and_tasks
    without_roles.select do |project|
      project.tasks.empty?
    end
  end

  def without_roles_with_tasks
    without_roles.select do |project|
      project.tasks.any?
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

  def roles
    projects.select(&:a_role?)
  end

  def without_roles
    projects.reject(&:a_role?)
  end

  def without_roles_assigned
    without_roles.reject(&:role_present?)
  end

  def create(project)
    self.projects += [project]
  end

  def update(project)
    delete(project)
    create(project)
  end

  def delete(project)
    projects.delete_if { |p| p.asana_id == project.asana_id }
  end
end
