class TaskObject < BaseObject
  attribute :asana_id, String
  attribute :name, String
  attribute :assignee_id, String
  attribute :description, String
  attribute :modified_at, DateTime
  attribute :tags, Array
  attribute :due_at, DateTime
  attribute :completed, Boolean

  STALE_TIME = 4.weeks
  STALE_TAG_NAME = 'stale'
  IGNORED_TAGS_NAMES = ['maybe later', 'blocked', 'waiting for']

  def stale_task?
    modified_at && modified_at < STALE_TIME.ago &&
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

  def forgotten_task?
    stale_task? && stale_tag?
  end

  def stale_tag?
    tags.map(&:name).include?(STALE_TAG_NAME)
  end

  def uncompleted?
    !completed
  end
end
