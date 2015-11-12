class TaskObject
  include Virtus.model

  attribute :asana_id, String
  attribute :name, String
  attribute :assignee, Array
end
