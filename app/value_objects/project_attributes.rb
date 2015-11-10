class ProjectAttributes < Hash
  def initialize(name)
    super(
      workspace: A9n.asana[:workspace_id],
      team: A9n.asana[:team_id],
      name: "@#{name}"
    )
  end
end
