class AsanaRolesUpdater
  attr_accessor :asana_client

  def initialize(asana_client)
    self.asana_client = asana_client
  end

  def perform(diff)
    { to_create: to_create(diff), to_delete: to_delete(diff) }
  end

  private

  def to_create(diff)
    to_create = diff[:to_create] || []
    to_create.map do |r|
      project = asana_client.create_project(workspace: A9n.asana[:workspace_id],
                                            team: A9n.asana[:team_id],
                                            name: "@#{r.name}")
      new_attributes = r.attributes.merge(asana_id: project.id)
      RoleObject.new(new_attributes)
    end
  end

  def to_delete(diff)
    to_delete = diff[:to_delete] || []
    to_delete.map do |r|
      asana_client.delete_project(r.asana_id)
      r
    end
  end
end
