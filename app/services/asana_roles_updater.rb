class AsanaRolesUpdater < BaseService
  takes :asana_client

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
      role_attributes = ProjectAttributes.new(decorate_role(r.name),
                                              r.asana_team_id)
      project = asana_client.create_project(role_attributes)
      new_attributes = r.attributes.merge(asana_id: project.id)
      RoleObject.new(new_attributes)
    end
  end

  def to_delete(diff)
    map(diff[:to_delete]) do |r|
      asana_client.delete_project(r.asana_id)
      r
    end
  end

  def to_update(diff)
    map(diff[:to_update]) do |r|
      name = r.attributes[:name]
      new_attributes = r.attributes.merge(name: decorate_role(name))
      asana_client.update_project(r.asana_id, new_attributes)
      r
    end
  end

  def map(roles, &block)
    roles ||= []
    roles.map do |r|
      block.call(r)
    end
  end

  def decorate_role(name)
    "@#{name}"
  end
end
