class AsanaRolesUpdater
  attr_accessor :asana_client

  def initialize(asana_client)
    self.asana_client = asana_client
  end

  def perform(diff)
    diff[:to_create].each do |r|
      asana_client.create_project(workspace: A9n.asana[:workspace_id],
                                  team: A9n.asana[:team_id],
                                  name: "@#{r.name}")
    end
  end
end
