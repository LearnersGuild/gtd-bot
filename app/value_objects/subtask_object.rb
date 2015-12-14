class SubtaskObject < BaseObject
  attribute :asana_id, String
  attribute :name, String
  attribute :assignee_id, String
  attribute :completed, Boolean

  def uncompleted?
    !completed
  end
end
