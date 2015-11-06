class GlassFrog
  attr_accessor :client

  def initialize
    self.client = Glassfrog::Client.new(
      api_key: A9n.glass_frog[:api_key],
      caching: false
    )
  end

  def roles
    client.get(:roles)
  end
end
