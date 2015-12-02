class TaskTagger < BaseService
  takes :tasks_repository, :tags_repository

  def perform(tasks, tag_name)
    tag = tags_repository.find_or_create(tag_name)
    tasks.each do |task|
      unless task.tags.include?(tag)
        tasks_repository.add_tag_to_task(task, tag)
      end
    end
  end
end
