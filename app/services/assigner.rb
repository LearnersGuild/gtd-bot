class Assigner < BaseService
  takes :repository, :parallel_iterator

  def perform(collection, assignee_id)
    parallel_iterator.each(collection) do |object|
      repository.update(object, assignee: assignee_id)
    end
  end
end
