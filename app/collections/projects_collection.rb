class ProjectsCollection < BaseCollection
  inject :roles_repository

  def initialize(items = [])
    super
    self.items = items.reject(&:underscored?)
  end

  def without_roles
    reject(&:a_role?)
  end

  def without_tasks
    select { |p| p.tasks.empty? }
  end

  def with_tasks
    select { |p| p.tasks.any? }
  end

  def individual
    select(&:individual?)
  end

  def everyone
    select(&:everyone?)
  end

  def roles
    select(&:a_role?)
  end

  def without_roles_assigned
    existing_roles = roles_repository.all
    without_roles.select { |p| p.linked_role_ids(existing_roles).empty? }
  end
end
