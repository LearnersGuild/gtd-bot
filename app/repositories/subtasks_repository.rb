class SubtasksRepository < BaseRepository
  def update(subtask, attributes)
    updated_subtask = asana_client.update_subtask(subtask.asana_id, attributes)
    subtask.update(updated_subtask.attributes) if updated_subtask
  end

  private

  def default_collection
    SubtasksCollection.new
  end
end
