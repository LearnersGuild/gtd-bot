class GlassFrogClient
  attr_accessor :client, :team_object_factory, :role_object_factory

  def initialize(team_object_factory, role_object_factory)
    self.client = Glassfrog::Client.new(
      api_key: ENV.fetch('GLASSFROG_API_KEY'),
      caching: false
    )
    self.team_object_factory = team_object_factory
    self.role_object_factory = role_object_factory
  end

  def circles
    client.get(:circles).map { |c| team_object_factory.from_glass_frog(c) }
  end

  def roles
    client.get(:roles).map { |r| role_object_factory.from_glass_frog(r) }
  end
end
