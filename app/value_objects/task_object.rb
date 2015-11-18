class TaskObject < BaseObject
  attribute :asana_id, String
  attribute :name, String
  attribute :assignee_id, String
  attribute :description, String
  attribute :modified_at, DateTime
  attribute :tags, Array
  attribute :due_at, DateTime
  STALE_TIME = 10.minutes.ago
  IGNORED_TAGS_NAMES = ['maybe later', 'blocked', 'waiting for']

  def stale_task?
    modified_at && modified_at < STALE_TIME &&
      !ignored_tags? && !due_at_in_future?
  end

  def assigned_to?(id)
    assignee_id == id
  end

  def ignored_tags?
    (IGNORED_TAGS_NAMES & tags.map(&:name)).any?
  end

  def due_at_in_future?
    due_at && due_at > DateTime.now
  end
end
