class GlassFrogClient
  attr_accessor :client, :role_object_factory

  def initialize(role_object_factory)
    self.client = Glassfrog::Client.new(
      api_key: A9n.glass_frog[:api_key],
      caching: false
    )
    self.role_object_factory = role_object_factory
  end

  def roles
    client.get(:roles).map { |r| role_object_factory.from_glass_frog(r) }
  end
end
