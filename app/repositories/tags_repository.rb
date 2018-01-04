class TagsRepository < BaseRepository
  def initialize(asana_client)
    self.asana_client = asana_client

    all_tags = asana_client.all_tags(ENV.fetch('ASANA_WORKSPACE_ID'))
    self.collection = TagsCollection.new(all_tags)
  end

  def find_or_create(name)
    find(name) || create(name)
  end

  def find(name)
    @collection.detect { |t| t.name == name }
  end

  def create(name)
    return if name.blank?

    tag = asana_client.create_tag(ENV.fetch('ASANA_WORKSPACE_ID'), name: name)
    @collection.add(tag)
  end

  def add_to_task(task, tag)
    success = asana_client.add_tag_to_task(task.asana_id, tag.asana_id)
    if success
      task.tags.push(tag)
      # We need to update modified_at manually because Asana returns tag object,
      # additional gem doesn't update modified_at field in Asana::Task object
      task.update(modified_at: DateTime.now)
    end
  end
end
