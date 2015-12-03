class BaseRepository
  attr_accessor :asana_client, :collection

  def initialize(asana_client, collection = nil)
    self.asana_client = asana_client
    self.collection = collection || default_collection
  end

  private

  def method_missing(method, *args, &block)
    @collection.send(method, *args, &block)
  end
end
