class TaskTagger < BaseService
  takes :asana_client

  def perform(tasks, tag_name)
    all_tags = asana_client.all_tags(A9n.asana[:workspace_id])
    tag_creator = TagFactory.new(asana_client, all_tags)
    tag = tag_creator.find_or_create(tag_name)
    tasks.each do |task|
      unless task.tags.include?(tag)
        asana_client.add_tag_to_task(task.asana_id, tag.asana_id)
      end
    end
  end
end
