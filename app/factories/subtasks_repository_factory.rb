class SubtasksRepositoryFactory
  takes :asana_client

  def new(subtasks)
    collection = SubtasksCollection.new(subtasks)
    SubtasksRepository.new(asana_client, collection)
  end
end
