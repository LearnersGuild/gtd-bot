class TagFactory
  attr_accessor :asana_client, :existing_tags, :workspace

  def initialize(asana_client)
    self.asana_client = asana_client
    self.workspace = A9n.asana[:workspace_id]
    self.existing_tags = asana_client.all_tags(workspace)
  end

  def find_or_create(name)
    find(name) || create(name)
  end

  def find(name)
    existing_tags.detect { |t| t.name == name }
  end

  def create(name)
    return if name.blank?
    tag = name && asana_client.create_tag(workspace, name: name)
    self.existing_tags += [tag]
    tag
  end
end
