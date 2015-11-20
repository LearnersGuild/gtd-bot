class TagFactory
  takes :asana_client, :existing_tags

  def find_or_create(name)
    find(name) || create(name)
  end

  def find(name)
    existing_tags.detect { |t| t.name == name }
  end

  def create(name)
    return if name.blank?

    tag = name && asana_client.create_tag(A9n.asana[:workspace_id], name: name)
    @existing_tags.push(tag)
    tag
  end
end
