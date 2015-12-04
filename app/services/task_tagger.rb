class TaskTagger < BaseService
  takes :tags_repository, :parallel_iterator

  def perform(tasks, tag_name)
    tag = tags_repository.find_or_create(tag_name)
    parallel_iterator.each(tasks) do |task|
      next if task.tags.include?(tag)

      add_tag(task, tag)
    end
  end

  private

  def add_tag(task, tag)
    logger.info("Adding tags to task #{task.name}")
    tags_repository.add_to_task(task, tag)
    logger.info("Tag added")
  end
end
