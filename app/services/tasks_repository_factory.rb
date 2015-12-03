class TasksRepositoryFactory
  takes :asana_client

  def new(collection)
    TasksRepository.new(asana_client, collection)
  end
end
