class Assigner < BaseService
  takes :repository

  def perform(collection, assignee_id)
    collection.each do |object|
      repository.update(object, assignee: assignee_id)
    end
  end
end
