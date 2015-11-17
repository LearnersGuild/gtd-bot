class TaskTagger
  attr_accessor :asana_client, :tag_factory, :existing_tags

  def initialize(asana_client, tag_factory)
    self.asana_client = asana_client
    self.tag_factory = tag_factory
    self.existing_tags = asana_client.all_tags(A9n.asana[:workspace_id])
  end

  def perform(tasks, tag_name)
    tag = get_tag(tag_name) || create_new_tag(tag_name)
    tasks.each do |task|
      asana_client.add_tag_to_task(task.asana_id, tag.asana_id)
    end
  end

  private

  def get_tag(name)
    existing_tags.detect { |t| t.name == name }
  end

  def create_new_tag(name)
    tag_factory.perform(name)
  end
end
