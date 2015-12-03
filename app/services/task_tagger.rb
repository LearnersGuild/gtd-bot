class TaskTagger < BaseService
  takes :asana_client, :parallel_iterator

  def perform(tasks, tag_name)
    all_tags = asana_client.all_tags(A9n.asana[:workspace_id])
    tag_creator = TagFactory.new(asana_client, all_tags)
    tag = tag_creator.find_or_create(tag_name)
    parallel_iterator.each(tasks) do |task|
      next if task.tags.include?(tag)

      add_tag(task, tag)
    end
  end

  private

  def add_tag(task, tag)
    logger.info("Adding tags to task #{task.name}")
    asana_client.add_tag_to_task(task.asana_id, tag.asana_id)
    logger.info("Tag added")
  end
end
