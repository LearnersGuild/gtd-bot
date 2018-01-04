class TaskObject < BaseObject
  attribute :asana_id, String
  attribute :name, String
  attribute :assignee_id, String
  attribute :description, String
  attribute :modified_at, DateTime
  attribute :tags, Array
  attribute :due_at, DateTime
  attribute :due_on, Date
  attribute :completed, Boolean
  attribute :project_ids, Array, default: []
  attribute :follower_ids, Array, default: []
  attribute :subtasks, Array

  STALE_TIME = 4.weeks
  STALE_TAG_NAME = 'stale'
  IGNORED_TAGS_NAMES = ['maybe later', 'blocked', 'waiting for']
  IGNORE_DURING_UPDATE_FROM_ASANA = [:project_ids, :tags]
  MODIFIED_SINCE = 5.minutes

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
    time = due_at || due_on
    time && time > DateTime.now
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

  def attributes_to_update_from_asana
    attributes.reject { |k, _| IGNORE_DURING_UPDATE_FROM_ASANA.include?(k) }
  end

  def modified_since(time = MODIFIED_SINCE)
    modified_at && modified_at > time.ago
  end
end
