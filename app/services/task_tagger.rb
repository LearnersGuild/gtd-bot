class TaskTagger < BaseService
  takes :tags_repository, :parallel_iterator, :strategies_repository

  def perform(tasks, tag_name)
    tag = tags_repository.find_or_create(tag_name)
    parallel_iterator.each(tasks) do |task|
      next if task.tags.include?(tag)
      next if strategies_repository.already_performed?(self, task)

      add_tag(task, tag)
      strategies_repository.register_performing(self, task)
    end
  end

  private

  def add_tag(task, tag)
    logger.info("Adding tags to task #{task.name}")
    tags_repository.add_to_task(task, tag)
    logger.info("Tag added")
  end
end
