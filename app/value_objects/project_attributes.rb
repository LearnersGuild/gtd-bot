class ProjectAttributes < Hash
  def initialize(name)
    super()
    self[:workspace] = A9n.asana[:workspace_id]
    self[:team] = A9n.asana[:team_id]
    self[:name] = name
  end
end
