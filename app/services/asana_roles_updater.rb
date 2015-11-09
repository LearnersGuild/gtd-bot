class AsanaRolesUpdater
  attr_accessor :asana_client

  def initialize(asana_client)
    self.asana_client = asana_client
  end

  def perform(diff)
    to_create = diff[:to_create].map do |r|
      project = asana_client.create_project(workspace: A9n.asana[:workspace_id],
                                            team: A9n.asana[:team_id],
                                            name: "@#{r.name}")
      new_attributes = r.attributes.merge(asana_id: project.id)
      RoleObject.new(new_attributes)
    end

    { to_create: to_create }
  end
end
