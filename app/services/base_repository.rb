class BaseRepository
  takes :collection, :asana_client

  private

  def method_missing(method, *args, &block)
    @projects_collection.send(method, *args, &block)
  end
end
