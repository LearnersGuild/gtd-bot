class GlassFrogClient
  attr_accessor :client, :team_object_factory

  def initialize(team_object_factory)
    self.client = Glassfrog::Client.new(
      api_key: A9n.glass_frog[:api_key],
      caching: false
    )
    self.team_object_factory = team_object_factory
  end

  def circles
    client.get(:circles).map { |c| team_object_factory.from_glass_frog(c) }
  end
end
