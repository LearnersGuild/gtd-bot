class SubtasksRepository < BaseRepository
  def update(subtask, attributes)
    new_attributes = subtask.attributes.merge(attributes)
    asana_client.update_task(subtask.asana_id, attributes)
    subtask.update(new_attributes)
  end

  private

  def default_collection
    SubtasksCollection.new
  end
end
