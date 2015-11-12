class TaskObject
  include Virtus.model

  attribute :asana_id, String
  attribute :name, String
end
