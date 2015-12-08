class TasksRepositoryFactory
  takes :asana_client

  def new(tasks)
    collection = TasksCollection.new(tasks)
    TasksRepository.new(asana_client, collection)
  end
end
