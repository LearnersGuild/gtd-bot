class TaskTagger
  takes :asana_client, :tag_factory

  def perform(tasks, tag_name)
    tag = tag_factory.find_or_create(tag_name)
    tasks.each do |task|
      asana_client.add_tag_to_task(task.asana_id, tag.asana_id)
    end
  end
end
