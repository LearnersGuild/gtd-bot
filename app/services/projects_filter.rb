class ProjectsFilter < BaseService
  attr_accessor :projects

  inject :roles_repository

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
    existing_roles = roles_repository.all
    without_roles.select { |p| p.linked_role_ids(existing_roles).empty? }
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
