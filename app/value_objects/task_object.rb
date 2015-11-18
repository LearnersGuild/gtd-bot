class TaskObject < BaseObject
  attribute :asana_id, String
  attribute :name, String
  attribute :assignee_id, String
  attribute :description, String
  attribute :modified_at, DateTime
  attribute :tags, Array
  STALE_TIME = 30.minutes.ago

  def stale_task?
    modified_at && modified_at < STALE_TIME
  end

  def assigned_to?(id)
    assignee_id == id
  end
end
