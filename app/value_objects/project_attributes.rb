class ProjectAttributes < Hash
  def initialize(name, team_id)
    super()
    self[:workspace] = A9n.asana[:workspace_id]
    self[:team] = team_id
    self[:name] = name
  end
end
