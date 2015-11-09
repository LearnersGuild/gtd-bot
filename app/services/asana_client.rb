class AsanaClient
  attr_accessor :client

  def initialize
    self.client = Asana::Client.new do |c|
      c.authentication(:access_token, A9n.asana[:api_key])
    end
  end

  def create_project(attributes)
    Asana::Project.create(client, attributes)
  end

  def delete_project(project_id)
    project = Asana::Project.new({ id: project_id }, { client: client })
    project.delete
  end
end
