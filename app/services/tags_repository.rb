class TagsRepository < BaseRepository
  def initialize(asana_client)
    self.asana_client = asana_client

    all_tags = asana_client.all_tags(A9n.asana[:workspace_id])
    self.collection = self.class.new(all_tags)
  end

  def find_or_create(name)
    find(name) || create(name)
  end

  def find(name)
    @collection.detect { |t| t.name == name }
  end

  def create(name)
    return if name.blank?

    tag = asana_client.create_tag(A9n.asana[:workspace_id], name: name)
    @collection.push(tag)
  end
end
