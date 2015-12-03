class TaskTagger < BaseService
  takes :tags_repository

  def perform(tasks, tag_name)
    tag = tags_repository.find_or_create(tag_name)
    tasks.each do |task|
      unless task.tags.include?(tag)
        tags_repository.add_to_task(task, tag)
      end
    end
  end
end
