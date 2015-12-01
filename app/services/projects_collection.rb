class ProjectsCollection < BaseService
  takes :projects
  inject :roles_repository

  delegate :include?, :select, :each, to: :projects

  def without_roles
    select_collection { projects.reject(&:a_role?) }
  end

  def without_tasks
    select_collection do
      projects.select { |p| p.tasks.empty? }
    end
  end

  def with_tasks
    select_collection do
      projects.select { |p| p.tasks.any? }
    end
  end

  def individual
    select_collection { projects.select(&:individual?) }
  end

  def roles
    select_collection { projects.select(&:a_role?) }
  end

  def without_roles_assigned
    select_collection do
      existing_roles = roles_repository.all
      without_roles.select { |p| p.linked_role_ids(existing_roles).empty? }
    end
  end

  def create(project)
    @projects += [project]
  end

  def update(project)
    delete(project)
    create(project)
  end

  def delete(project)
    projects.delete_if { |p| p.asana_id == project.asana_id }
  end

  def ==(other)
    projects == other.projects
  end

  private

  def select_collection(&block)
    collection = block.call
    ProjectsCollection.new(collection)
  end
end
