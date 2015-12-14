class SubtasksRepository < BaseRepository
  def update(subtask, attributes)
    new_attributes = subtask.attributes.merge(attributes)
    success = asana_client.update_task(subtask.asana_id, attributes)
    subtask.update(new_attributes) if success
  end

  private

  def default_collection
    SubtasksCollection.new
  end
end
