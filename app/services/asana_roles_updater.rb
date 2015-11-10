class AsanaRolesUpdater
  attr_accessor :asana_client

  def initialize(asana_client)
    self.asana_client = asana_client
  end

  def perform(diff)
    {
      to_create: to_create(diff),
      to_delete: to_delete(diff),
      to_update: to_update(diff)
    }
  end

  private

  def to_create(diff)
    foo(diff[:to_create]) do |r|
      project = asana_client.create_project(ProjectAttributes.new(r.name))
      new_attributes = r.attributes.merge(asana_id: project.id)
      RoleObject.new(new_attributes)
    end
  end

  def to_delete(diff)
    foo(diff[:to_delete]) do |r|
      asana_client.delete_project(r.asana_id)
      r
    end
  end

  def to_update(diff)
    foo(diff[:to_update]) do |r|
      asana_client.update_project(r.asana_id, r.attributes)
      r
    end
  end

  def foo(roles, &block)
    roles ||= []
    roles.map do |r|
      block.call(r)
    end
  end
end
