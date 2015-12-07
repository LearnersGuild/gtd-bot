class AsanaRolesUpdater < BaseService
  takes :projects_repository

  def perform(diff)
    {
      to_create: to_create(diff),
      to_delete: to_delete(diff),
      to_update: to_update(diff)
    }
  end

  private

  def to_create(diff)
    map(diff[:to_create]) do |r|
      project = projects_repository.create(r.asana_team_id, r.role_attributes)
      new_attributes = r.attributes.merge(asana_id: project.asana_id)
      RoleObject.new(new_attributes)
    end
  end

  def to_delete(diff)
    map(diff[:to_delete]) do |r|
      projects_repository.delete(r.asana_id)
      r
    end
  end

  def to_update(diff)
    map(diff[:to_update]) do |r|
      projects_repository.update(r.asana_id, r.role_attributes)
      r
    end
  end

  def map(roles, &block)
    roles ||= []
    roles.map do |r|
      block.call(r)
    end
  end
end
